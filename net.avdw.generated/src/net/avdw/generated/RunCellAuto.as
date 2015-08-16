package net.avdw.generated
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.generated.cellauto.cell.*;
	import net.avdw.generated.cellauto.CellAutoWorld;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RunCellAuto extends Sprite
	{
		private var world:CellAutoWorld;
		
		public function RunCellAuto()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			world = new CellAutoWorld(128, 64, 5, 5);
			world.init([{type: ForestFireCell, distribution: 1}]);
			addChild(world);
			
			stage.frameRate = 8;
			
			addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function step(e:Event):void 
		{
			world.step();
		}
	
	}

}