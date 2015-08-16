package net.avdw.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 				┌∩┐'(◣_◢)'┌∩┐
	 * @author Andrew van der Westhuizen 
	 */
	public class MainAudioWave extends Sprite 
	{
		
		public function MainAudioWave():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(new GuiAudioWave());
			
			/*const verticalGroup:GuiVerticalGroup = new GuiVerticalGroup();
			verticalGroup.add(new GuiButton("Short"));
			verticalGroup.add(new GuiButton("A bit long"));
			verticalGroup.add(new GuiButton("A bit longer again"));
			verticalGroup.add(new GuiButton("Short"));
			addChild(verticalGroup);*/
		}
		
	}
	
}