package net.avdw.gui
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiPanel extends AGuiComponent
	{
		private var padding:int;
		
		public function GuiPanel(padding:int = 10)
		{
			this.padding = padding;
			filters = [new GlowFilter(0x181818, 1, 12, 12, 2, 1, true)]
		}
		
		public function add(displayObject:DisplayObject):void
		{
			addChild(displayObject);
			refresh();
		}
		
		override public function refresh():void
		{
			graphics.clear();
			graphics.beginFill(0x464646);
			graphics.drawRect(0, 0, width + 2 * padding, height + 2 * padding);
			graphics.endFill();
			
			for (var idx:int = numChildren - 1; idx >= 0; idx--)
			{
				getChildAt(idx).x = (width - getChildAt(idx).width) >> 1;
				getChildAt(idx).y = (height - getChildAt(idx).height) >> 1;
			}
		
		}
	
	}

}