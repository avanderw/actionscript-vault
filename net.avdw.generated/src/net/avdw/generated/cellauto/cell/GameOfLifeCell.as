package net.avdw.generated.cellauto.cell 
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GameOfLifeCell extends ACell
	{
		public var alive:Boolean;
		public var wasAlive:Boolean;
		
		public function GameOfLifeCell(cellWidth:int, cellHeight:int) 
		{
			super(cellWidth, cellHeight);
			this.alive = Math.random() > .5;
		}
		
		override public function step():void
		{
			var surrounding:int = countSurroundingCells("wasAlive", true);
			this.alive = surrounding === 3 || surrounding === 2 && alive;
		}
		
		override public function save():void
		{
			wasAlive = alive;
		}
		
		override public function render():void
		{
			graphics.clear();
			if (alive) {
				graphics.beginFill(0x804000);
				graphics.drawRect(0, 0, cellWidth, cellHeight);
				graphics.endFill();
			}
		}
		
		override public function toString():String
		{
			return alive ? "G" : " ";
		}
		
	}

}