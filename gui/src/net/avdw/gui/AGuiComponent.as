package net.avdw.gui 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class AGuiComponent extends Sprite
	{
		public function AGuiComponent():void 
		{
		}
		
		/* INTERFACE net.avdw.gui.IGuiComponent */
		
		public function refresh():void 
		{
			throw new Error("method is abstract");
		}
	}
	
}