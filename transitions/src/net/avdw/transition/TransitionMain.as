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
	import net.avdw.gui.GuiPanel;
	import net.avdw.gui.GuiVerticalGroup;
	
	/**
	 * 				┌∩┐'(◣_◢)'┌∩┐
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
			//imageContainer.filters = [new DropShadowFilter];
			for each (var img:Bitmap in images)
			{
				img.visible = false;
				imageContainer.addChild(img);
			}
			images[images.length - 1].visible = true;
			
			const leftButtonGroup:GuiVerticalGroup = new GuiVerticalGroup();
			leftButtonGroup.add(new GuiButton("Fade", button_onClicked, new TransitionFade()));
			leftButtonGroup.add(new GuiButton("Horizontal Bars", button_onClicked, new TransitionHorizontalBars()));
			leftButtonGroup.add(new GuiButton("Horizontal Blinds", button_onClicked, new TransitionHorizontalBars()));
			leftButtonGroup.add(new GuiButton("Horizontal Blocks", button_onClicked, new TransitionHorizontalBars()));
			leftButtonGroup.add(new GuiButton("Horizontal Slide", button_onClicked, new TransitionHorizontalBars()));
			leftButtonGroup.add(new GuiButton("Horizontal Zip", button_onClicked, new TransitionHorizontalBars()));
			//leftButtonGroup.filters = [new DropShadowFilter()];
			
			const rightButtonGroup:GuiVerticalGroup = new GuiVerticalGroup();
			rightButtonGroup.add(new GuiButton("Vertical Bars", button_onClicked, new TransitionHorizontalBars()));
			rightButtonGroup.add(new GuiButton("Vertical Blinds", button_onClicked, new TransitionHorizontalBars()));
			rightButtonGroup.add(new GuiButton("Vertical Blocks", button_onClicked, new TransitionHorizontalBars()));
			rightButtonGroup.add(new GuiButton("Vertical Slide", button_onClicked, new TransitionHorizontalBars()));
			rightButtonGroup.add(new GuiButton("Vertical Zip", button_onClicked, new TransitionHorizontalBars()));
			//rightButtonGroup.filters = [new DropShadowFilter()];
			
			const horizontalGroup:GuiHorizontalGroup = new GuiHorizontalGroup(5);
			horizontalGroup.add(leftButtonGroup);
			horizontalGroup.add(imageContainer);
			horizontalGroup.add(rightButtonGroup);
			
			const panel:GuiPanel = new GuiPanel();
			panel.add(horizontalGroup);
			panel.x = (stage.stageWidth - panel.width) >> 1;
			panel.y = (stage.stageHeight - panel.height) >> 1;
			addChild(panel);
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