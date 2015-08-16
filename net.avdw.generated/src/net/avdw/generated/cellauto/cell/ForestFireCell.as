package net.avdw.generated.cellauto.cell
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ForestFireCell extends ACell
	{
		private const CHANCE_TO_IGNITE:Number = 0.0001;
		private const CHANCE_TO_GROW:Number = 0.01;
		
		public var burning:int = 0;
		public var wasBurning:Boolean = false;
		public var alive:Boolean = false;
		
		public function ForestFireCell(cellWidth:int, cellHeight:int)
		{
			super(cellWidth, cellHeight);
			this.wasBurning = this.burning != 0;
		}
		
		override public function step():void
		{
			if (this.wasBurning)
				this.burning -= 3;
			else if (this.alive)
			{
				var surrounding:int = this.countSurroundingCells('wasBurning', true);
				if (surrounding > 0)
				{
					this.burning = 9;
					this.alive = false;
				}
				else if (Math.random() < CHANCE_TO_IGNITE)
				{
					this.burning = 9;
					this.alive = false;
				}
			}
			else if (Math.random() < CHANCE_TO_GROW)
			{
				this.alive = true;
			}
		}
		
		override public function save():void
		{
			this.wasBurning = this.burning !== 0;
		}
		
		override public function render():void
		{
			graphics.clear();
			graphics.beginFill(this.burning ? 0xD04648 : this.alive ? 0x346524 : 0xFFFFFF, this.burning ? Math.max(0.3, this.burning / 9) : 1);
			graphics.drawRect(0, 0, cellWidth, cellHeight);
			graphics.endFill();
		}
		
		override public function toString():String
		{
			return alive ? "F" : " ";
		}
	}

}