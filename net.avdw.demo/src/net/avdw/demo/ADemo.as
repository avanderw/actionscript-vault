package net.avdw.demo 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.align.alignHorizontalRightTo;
	import net.avdw.font.FontMarioKartDs;
	import net.avdw.text.embeddedFont;
	import net.hires.debug.Stats;
	
	public class ADemo extends Sprite
	{
		public function ADemo() 
		{
			if (stage) setup();
			else addEventListener(Event.ADDED_TO_STAGE, setup);
		}	
		
		private function setup(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, setup);
			CONFIG::debug {
				var stats:Stats = new Stats();
				stage.addChild(stats);
				alignHorizontalRightTo(stage, stats);
				stage.addChild(embeddedFont("DEBUG BUILD", FontMarioKartDs.NAME, 14, 0xFF0000));
			}
		}
	}
}