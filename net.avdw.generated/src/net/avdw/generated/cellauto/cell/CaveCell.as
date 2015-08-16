package net.avdw.generated.cellauto.cell
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CaveCell extends ACell
	{
		public var open:Boolean;
		public var wasOpen:Boolean;
		
		public function CaveCell(cellWidth:int, cellHeight:int)
		{
			super(cellWidth, cellHeight);
			
			open = Math.random() > .4;
		}
		
		override public function step():void
		{
			var surrounding:int = countSurroundingCells("wasOpen", true);
			open = !isBorder && (wasOpen && surrounding >= 4 || surrounding >= 6);
		}
		
		override public function save():void
		{
			wasOpen = open;
		}
		
		override public function render():void
		{
			graphics.clear();
			if (!open) {
				graphics.beginFill(0x442434);
				graphics.drawRect(0, 0, cellWidth, cellHeight);
				graphics.endFill();
			}
		}
		
		override public function toString():String
		{
			return !open ? "C" : " ";
		}
	}
}