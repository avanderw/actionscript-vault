package net.avdw.gui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiMain extends Sprite 
	{
		
		public function GuiMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			const verticalGroup:GuiVerticalGroup = new GuiVerticalGroup();
			verticalGroup.add(new GuiButton("Short"));
			verticalGroup.add(new GuiButton("A bit long"));
			verticalGroup.add(new GuiButton("A bit longer again"));
			verticalGroup.add(new GuiButton("Short"));
			addChild(verticalGroup);
		}
		
	}
	
}