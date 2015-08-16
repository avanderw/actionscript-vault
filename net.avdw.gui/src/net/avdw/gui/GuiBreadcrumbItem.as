package net.avdw.gui
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import net.avdw.font.FontConsolas;
	import net.avdw.suite.SuitePage;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiBreadcrumbItem extends Sprite
	{
		static private const itemBevelFilter:BevelFilter = new BevelFilter(1, 0, 0xFFFFFF, .5, 0, .5, 0, 0, 4);
		static private const badgeBevelFilter:BevelFilter = new BevelFilter(1, 45, 0, .5, 0xFFFFFF, .5, 0, 0, 4);
		static public const PADDING:int = 3;
		private const titleText:TextField = FontConsolas.createTextfied("", 16, 0xFFFFFF);
		private const gradientBox:Matrix = new Matrix();
		
		private var badge:int;
		private var title:String;
		public var page:SuitePage;
		
		public function GuiBreadcrumbItem(page:SuitePage, title:String = "", badge:int = 0)
		{
			this.page = page;
			this.title = title;
			this.badge = badge;
			
			titleText.text = title;
			titleText.y = PADDING;
			
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function update():void {
			if (parent.getChildIndex(this) == parent.numChildren-1) {
				color(0x20E8E8, 0x1D7081);
				removeEventListener(MouseEvent.ROLL_OVER, this_onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, this_onRollOut);
			}
			else
			{
				color();
				addEventListener(MouseEvent.ROLL_OVER, this_onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, this_onRollOut);
			}
		}
		
		private function color(topColor:uint = 0x9F9F9F, bottomColor:uint = 0x5F5F5F):void
		{
			graphics.clear();
			
			const heightDiv2:int = height + 2 * PADDING >> 1;
			gradientBox.createGradientBox(width + 2 * PADDING, height + 2 * PADDING, Math.PI * .5);
			graphics.beginGradientFill(GradientType.LINEAR, [topColor, bottomColor], [1, 1], [0, 255], gradientBox);
			graphics.lineTo(width + heightDiv2 + 2 * PADDING, 0);
			graphics.lineTo(width + heightDiv2, heightDiv2);
			graphics.lineTo(width - heightDiv2, height + PADDING);
			graphics.lineTo(0, height);
			if (page.parent != null)
			{
				graphics.lineTo(heightDiv2, heightDiv2);
				titleText.x = (height >> 1) + PADDING;
			}
			else
			{
				titleText.x = (height >> 1);
			}
			graphics.endFill();
		}
		
		
		private function this_onRollOut(e:MouseEvent):void
		{
			color();
		}
		
		private function this_onRollOver(e:MouseEvent):void
		{
			color(0x20E8E8, 0x1D7081);
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			filters = [itemBevelFilter];
			addChild(titleText);
			update();
			
		}
	}

}