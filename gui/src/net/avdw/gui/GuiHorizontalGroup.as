package net.avdw.gui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 				┌∩┐'(◣_◢)'┌∩┐
	 * @author Andrew van der Westhuizen 
	 */
	public class GuiHorizontalGroup extends AGuiComponent
	{
		private var gap:int;
		
		public function GuiHorizontalGroup(gap:int = 1)
		{
			this.gap = gap;
		}
		
		public function add(displayObject:DisplayObject):void
		{
			displayObject.x = width + (numChildren == 0 ? 0 : gap);
			addChild(displayObject);
			refresh();
		}
		
		override public function refresh():void
		{
			for (var idx:int = numChildren - 1; idx >= 0; idx--)
			{
				if (getChildAt(idx) is AGuiComponent)
					(getChildAt(idx) as AGuiComponent).refresh();
			}
		}
	
	}

}