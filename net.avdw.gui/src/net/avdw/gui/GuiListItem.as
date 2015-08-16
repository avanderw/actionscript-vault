package net.avdw.gui
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import net.avdw.font.FontConsolas;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiListItem extends Sprite
	{
		static private const itemBevelFilter:BevelFilter = new BevelFilter(1, 45, 0xFFFFFF, .5, 0, .5, 0, 0, 4);
		static private const badgeBevelFilter:BevelFilter = new BevelFilter(1, 45, 0, .5, 0xFFFFFF, .5, 0, 0, 4);
		
		private var badge:int;
		private var title:String;
		public var data:Object;
		private const gradientBox:Matrix = new Matrix();
		private const padding:int = 3;
		private const badgeContainer:Sprite = new Sprite();
		private const textField:TextField = FontConsolas.createTextfied("", 16, 0xFFFFFF);
		private const badgeText:TextField = FontConsolas.createTextfied("", 16, 0xFFFFFF);
		
		public function GuiListItem(data:Object, title:String = "", badge:int = 0)
		{
			this.data = data;
			this.title = title;
			this.badge = badge;
			
			filters = [itemBevelFilter];
			textField.text = title;
			
			if (badge > 0)
			{
				badgeText.text = "" + badge;
				
				badgeContainer.filters = [badgeBevelFilter]
				badgeContainer.addChild(badgeText);
				
				badgeContainer.y = padding + 2;
				badgeText.x = padding;
				badgeText.y = -3;
				badgeContainer.x = textField.width + 4 * padding;
				
				addChild(badgeContainer);
			}
			textField.x = textField.y = padding;
			addChild(textField);
			
			addEventListener(MouseEvent.ROLL_OVER, this_onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, this_onRollOut);
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function update():void
		{
			color(0x9F9F9F, 0x5F5F5F);
			if (badge > 0)
			{
				badgeContainer.x = parent != null ? parent.width - badgeContainer.width - padding : textField.width + 4 * padding;
			}
		}
		
		private function color(topColor:uint, bottomColor:uint):void
		{
			graphics.clear();
			
			const bgHeight:int = height + 2 * padding;
			const bgWidth:int = Math.max(parent != null ? parent.width : 0, width + 2 * padding);
			
			gradientBox.createGradientBox(bgWidth, bgHeight, Math.PI * .5);
			graphics.beginGradientFill(GradientType.LINEAR, [topColor, bottomColor], [1, 1], [0, 255], gradientBox);
			graphics.drawRect(0, 0, bgWidth, bgHeight);
			graphics.endFill();
			
			if (badge > 0)
			{
				badgeContainer.graphics.clear();
				badgeContainer.graphics.beginFill(bottomColor);
				badgeContainer.graphics.drawRoundRect(0, 0, badgeText.width + 2 * padding, badgeText.height - 4, 20);
				badgeContainer.graphics.endFill();
			}
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			update();
		}
		
		private function this_onRollOut(e:MouseEvent):void
		{
			update();
		}
		
		private function this_onRollOver(e:MouseEvent):void
		{
			color(0x20E8E8, 0x1D7081);
		}
	
	}

}