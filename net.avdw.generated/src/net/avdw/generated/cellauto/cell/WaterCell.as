package net.avdw.generated.cellauto.cell 
{
	import flash.utils.Dictionary;
	import net.avdw.generated.cellauto.EPosition;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class WaterCell extends ACell 
	{
		
		public function WaterCell() 
		{
			
		}
		
		override public function step():void 
		{
			if (neighbours[EPosition.BOTTOM] != null) {
				if (neighbours[EPosition.BOTTOM] is NullAgent) {
					
				}
			}
		}
		
		public function toString():String {
			return "RA";
		}
	}

}