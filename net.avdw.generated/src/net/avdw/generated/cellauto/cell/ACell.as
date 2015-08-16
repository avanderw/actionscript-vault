package net.avdw.generated.cellauto.cell
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ACell extends Sprite
	{
		public const neighbours:Dictionary = new Dictionary();
		public var isBorder:Boolean = false;
		public var cellHeight:int;
		public var cellWidth:int;
		
		public function ACell(cellWidth:int, cellHeight:int):void {
			this.cellWidth = cellWidth;
			this.cellHeight = cellHeight;
		}
		
		public function countSurroundingCells(property:String, value:*):int {
			var count:int = 0;
			for each (var neighbour:ACell in neighbours)
				if (neighbour != null && neighbour[property] == value)
					count++;
			
			return count;
		}
		
		public function step():void
		{
			throw new Error("abstract: called when stepping through cells");
		}
		
		public function save():void
		{
			throw new Error("abstract: called after stepping through all cells");
		}
		
		public function render():void 
		{
			throw new Error("abstract: called after world finished stepping and is on stage");
		}
	}

}