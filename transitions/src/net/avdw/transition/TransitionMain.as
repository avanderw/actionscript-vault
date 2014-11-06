package net.avdw.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import mx.core.ButtonAsset;
	import net.avdw.gui.GuiButton;
	import net.avdw.gui.GuiHorizontalGroup;
	import net.avdw.gui.GuiVerticalGroup;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TransitionMain extends Sprite
	{
		[Embed(source="../../../../../images/game-wallpaper-1.jpg")]
		private const Image1:Class;
		[Embed(source="../../../../../images/game-wallpaper-2.jpg")]
		private const Image2:Class;
		[Embed(source="../../../../../images/game-wallpaper-3.jpg")]
		private const Image3:Class;
		[Embed(source="../../../../../images/game-wallpaper-4.jpg")]
		private const Image4:Class;
		
		private const images:Array = [new Image1(), new Image2(), new Image3(), new Image4()];
		
		public function TransitionMain():void
		{
			if (stage)
				this_addedToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			const imageContainer:Sprite = new Sprite();
			for each (var img:Bitmap in images)
			{
				img.visible = false;
				imageContainer.addChild(img);
			}
			images[images.length - 1].visible = true;
			
			const verticalGroup:GuiVerticalGroup = new GuiVerticalGroup();
			verticalGroup.add(new GuiButton("Fade", button_onClicked, new TransitionFade()));
			verticalGroup.add(new GuiButton("Vertical Bars", button_onClicked, new TransitionVerticalBars()));
			verticalGroup.add(new GuiButton("Horizontal Bars", button_onClicked, new TransitionHorizontalBars()));
			verticalGroup.filters = [new DropShadowFilter()];
			
			const horizontalGroup:GuiHorizontalGroup = new GuiHorizontalGroup(5);
			horizontalGroup.add(verticalGroup);
			horizontalGroup.add(imageContainer);
			addChild(horizontalGroup);
			
			horizontalGroup.x = (stage.stageWidth - horizontalGroup.width) >>1;
			horizontalGroup.y = (stage.stageHeight - horizontalGroup.height)>>1;
		}
		
		private function button_onClicked(transition:ITransition):void
		{
			const fromImage:DisplayObject = images.pop();
			const toImage:DisplayObject = images[images.length - 1];
			images.unshift(fromImage);
			
			transition.transition(fromImage, toImage);
		}
	}
}