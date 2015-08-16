package net.avdw.generated.cellauto
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import net.avdw.generated.cellauto.cell.ACell;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CellAutoWorld extends Sprite
	{
		private var worldWidth:int;
		private var worldHeight:int;
		private var cellWidth:int;
		private var cellHeight:int;
		
		public const grid:Vector.<Vector.<ACell>> = new Vector.<Vector.<ACell>>();
		
		public function CellAutoWorld(worldWidth:int, worldHeight:int, cellWidth:int = 1, cellHeight:int = 1)
		{
			this.cellHeight = cellHeight;
			this.cellWidth = cellWidth;
			this.worldWidth = worldWidth;
			this.worldHeight = worldHeight;
			
			addEventListener(Event.ADDED_TO_STAGE, render);
		}
		
		public function init(args:Array):void
		{
			var col:int;
			var row:int;
			var arg:Object;
			var sum:Number = 0;
			for each (arg in args)
				arg.distribution = sum += arg.distribution;
			
			if (sum < 1)
				trace("warning, distribution does not add up to 1");
			
			// init grid
			for (row = 0; row < worldHeight; row++)
			{
				var gridRow:Vector.<ACell> = new Vector.<ACell>();
				for (col = 0; col < worldWidth; col++)
				{
					var rand:Number = Math.random();
					for each (arg in args)
					{
						if (rand < arg.distribution)
						{
							gridRow.push(new arg.type(cellWidth, cellHeight));
							break;
						}
					}
				}
				
				grid.push(gridRow);
			}
			
			
			for (row = 0; row < worldHeight; row++)
			{
				for (col = 0; col < worldWidth; col++)
				{
					// border indicator
					grid[row][col].isBorder = col == 0 || row == 0 || col == worldWidth - 1 || row == worldHeight - 1;
					
					// setup neighbours
					grid[row][col].neighbours[EPosition.TOP_LEFT] = row > 0 && col > 0 ? grid[row - 1][col - 1] : null;
					grid[row][col].neighbours[EPosition.TOP] = row > 0 ? grid[row - 1][col] : null;
					grid[row][col].neighbours[EPosition.TOP_RIGHT] = row > 0 && col < worldWidth - 1 ? grid[row - 1][col + 1] : null;
					
					grid[row][col].neighbours[EPosition.LEFT] = col > 0 ? grid[row][col - 1] : null;
					grid[row][col].neighbours[EPosition.RIGHT] = col < worldWidth - 1 ? grid[row][col + 1] : null;
					
					grid[row][col].neighbours[EPosition.BOTTOM_LEFT] = row < worldHeight - 1 && col > 0 ? grid[row + 1][col - 1] : null;
					grid[row][col].neighbours[EPosition.BOTTOM] = row < worldHeight - 1 ? grid[row + 1][col] : null;
					grid[row][col].neighbours[EPosition.BOTTOM_RIGHT] = row < worldHeight - 1 && col < worldWidth - 1 ? grid[row + 1][col + 1] : null;
					
					// add to rendering
					addChild(grid[row][col]);
					grid[row][col].x = col * cellWidth;
					grid[row][col].y = row * cellHeight;
				}
			}
			
			render();
		}
		
		public function step(iterations:int = 1):void
		{
			var row:int;
			var col:int;
			
			for (var i:int = 0; i < iterations; i++)
			{
				// save the state of the cell
				for (row = 0; row < worldHeight; row++)
					for (col = 0; col < worldWidth; col++)
						grid[row][col].save();
						
				// step through each cell
				for (row = 0; row < worldHeight; row++)
					for (col = 0; col < worldWidth; col++)
						grid[row][col].step();
			}
		
			if (stage)
				render();
		}
		
		private function render(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, render);
			
			if (grid.length == worldHeight)
				for (var row:int = 0; row < worldHeight; row++)
					for (var col:int = 0; col < worldWidth; col++)
						grid[row][col].render();
		}
		
		override public function toString():String
		{
			var str:String = "";
			for each (var row:Vector.<ACell> in grid)
			{
				str += row + "\n";
			}
			return str;
		}
	}

}