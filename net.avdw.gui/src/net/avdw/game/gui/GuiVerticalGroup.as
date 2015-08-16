package net.avdw.game.gui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 				┌∩┐'(◣_◢)'┌∩┐
	 * @author Andrew van der Westhuizen 
	 */
	public class GuiVerticalGroup extends AGuiComponent
	{
		private var gap:int;
		
		public function GuiVerticalGroup(gap:int = 1)
		{
			this.gap = gap;
		}
		
		public function add(guiComponent:AGuiComponent):void
		{
			guiComponent.y = height + (numChildren == 0 ? 0 : gap);
			addChild(guiComponent);
			refresh();
		}
		
		override public function refresh():void
		{
			for (var idx:int = numChildren - 1; idx >= 0; idx--)
			{
				(getChildAt(idx) as AGuiComponent).refresh();
			}
		}
	
	}

}