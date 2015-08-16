package net.avdw.generated
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import net.avdw.math.random.randomSign;
	
	public class RunMaze extends Sprite
	{
		
		public function RunMaze()
		{
			addEventListener(Event.ENTER_FRAME, startup);
		}
		
		private function startup(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, startup);
			generate(10, 10, true);
		}
		
		static public function generate(width:int, height:int, weave:Boolean):void
		{
			var maze:Vector.<Vector.<MazeCell>> = initBlankMaze(width, height);
			makeMaze(maze, randomPoint(width, height), weave);
			renderText(maze, weave);
		}
		
		static private function randomPoint(width:int, height:int):Point { 
			return new Point(Math.floor(Math.random() * width), Math.floor(Math.random() * height));
		}
		
		static private function makeMaze(maze:Vector.<Vector.<MazeCell>>, from:Point, weave:Boolean):void
		{
			maze[from.y][from.x].visited = true;
			
			var directions:Vector.<int> = randomDirections();
			var to:Point;
			while (directions.length > 0)
			{
				var direction:int = directions.pop();
				to = toPoint(from, direction);
				
				if (inBounds(maze, to))
				{
					if (notVisited(maze, to))
					{
						maze[from.y][from.x].walls = removeWall(maze[from.y][from.x].walls, direction);
						maze[to.y][to.x].walls = removeWall(maze[to.y][to.x].walls, opposite(direction));
						makeMaze(maze, to, weave);
					}
					else if (weave && canWeave(maze, to, direction))
					{
						makeMaze(maze, weaveMaze(maze, from, true, direction), weave);
					}
				}
			}
		}
		
		static private function canWeave(maze:Vector.<Vector.<MazeCell>>, to:Point, direction:int):Boolean
		{
			if (notVisited(maze, to))
				return true;
			
			if ((maze[to.y][to.x].walls & (direction | opposite(direction))) == (direction | opposite(direction)) && !maze[to.y][to.x].weave)
			{
				if ((maze[to.y][to.x].walls & (cross(direction) | opposite(cross(direction)))) != (cross(direction) | opposite(cross(direction))))
				{
					to = toPoint(to, direction);
					return inBounds(maze, to) && canWeave(maze, to, direction);
				}
			}
			
			return false;
		}
		
		static private function weaveMaze(maze:Vector.<Vector.<MazeCell>>, from:Point, isFromStart:Boolean, direction:int):Point
		{
			if (isFromStart)
				maze[from.y][from.x].walls = removeWall(maze[from.y][from.x].walls, direction);
			else
				maze[from.y][from.x].weave = true;
			
			var to:Point = toPoint(from, direction);
			if (maze[to.y][to.x].visited)
				weaveMaze(maze, to, false, direction);
			
			maze[to.y][to.x].walls = removeWall(maze[to.y][to.x].walls, opposite(direction));
			
			return to;
		}
		
		static private function inBounds(maze:Vector.<Vector.<MazeCell>>, point:Point):Boolean
		{
			return point.y >= 0 && point.y < maze.length && point.x >= 0 && point.x < maze[0].length;
		}
		
		static private function notVisited(maze:Vector.<Vector.<MazeCell>>, point:Point):Boolean
		{
			return !maze[point.y][point.x].visited;
		}
		
		static public function removeWall(walls:int, direction:int):int
		{
			return walls &= ~direction & ((1 << 8) - 1);
		}
		
		static private function hasWall(walls:int, direction:int):Boolean
		{
			return (walls & direction) == direction;
		}
		
		static private function opposite(direction:int):int
		{
			switch (direction)
			{
				case MazeCell.NORTH: 
					return MazeCell.SOUTH;
				case MazeCell.SOUTH: 
					return MazeCell.NORTH;
				case MazeCell.EAST: 
					return MazeCell.WEST;
				case MazeCell.WEST: 
					return MazeCell.EAST;
				default: 
					throw new Error("Unknown direction");
			}
		}
		
		static private function cross(direction:int):int
		{
			switch (direction)
			{
				case MazeCell.NORTH: 
					return MazeCell.EAST;
				case MazeCell.SOUTH: 
					return MazeCell.WEST;
				case MazeCell.EAST: 
					return MazeCell.NORTH;
				case MazeCell.WEST: 
					return MazeCell.SOUTH;
				default: 
					throw new Error("Unknown direction");
			}
		}
		
		static private function initBlankMaze(width:int, height:int):Vector.<Vector.<MazeCell>>
		{
			var maze:Vector.<Vector.<MazeCell>> = new Vector.<Vector.<MazeCell>>();
			for (var row:int = 0; row < height; row++)
			{
				var rowData:Vector.<MazeCell> = new Vector.<MazeCell>();
				for (var col:int = 0; col < width; col++)
					rowData.push(new MazeCell());
				
				maze.push(rowData);
			}
			return maze;
		}
		
		static private function randomDirections():Vector.<int>
		{
			var directions:Vector.<int> = new Vector.<int>();
			directions.push(MazeCell.NORTH, MazeCell.SOUTH, MazeCell.EAST, MazeCell.WEST);
			directions.sort(function():int
				{
					return randomSign();
				});
			
			return directions;
		}
		
		static private function toPoint(from:Point, direction:int):Point
		{
			var to:Point;
			switch (direction)
			{
				case MazeCell.NORTH: 
					to = new Point(from.x, from.y - 1);
					break;
				case MazeCell.SOUTH: 
					to = new Point(from.x, from.y + 1);
					break;
				case MazeCell.EAST: 
					to = new Point(from.x + 1, from.y);
					break;
				case MazeCell.WEST: 
					to = new Point(from.x - 1, from.y);
					break;
			}
			
			return to;
		}
		
		static private function renderText(maze:Vector.<Vector.<MazeCell>>, weaved:Boolean):void
		{
			var tiles:Object = {};
			tiles[(MazeCell.WEST | MazeCell.SOUTH | MazeCell.EAST)] = ["│ │", "└─┘"];
			tiles[(MazeCell.WEST | MazeCell.NORTH | MazeCell.EAST)] = ["┌─┐", "│ │"];
			tiles[(MazeCell.WEST | MazeCell.EAST)] = ["│ │", "│ │"];
			tiles[(MazeCell.WEST | MazeCell.NORTH | MazeCell.SOUTH)] = ["┌──", "└──"];
			tiles[(MazeCell.WEST | MazeCell.SOUTH)] = ["│ └", "└──"];
			tiles[(MazeCell.WEST | MazeCell.NORTH)] = ["┌──", "│ ┌"];
			tiles[(MazeCell.WEST)] = ["│ └", "│ ┌"];
			tiles[(MazeCell.EAST | MazeCell.NORTH | MazeCell.SOUTH)] = ["──┐", "──┘"];
			tiles[(MazeCell.SOUTH | MazeCell.EAST)] = ["┘ │", "──┘"];
			tiles[(MazeCell.NORTH | MazeCell.EAST)] = ["──┐", "┐ │"];
			tiles[(MazeCell.EAST)] = ["┘ │", "┐ │"];
			tiles[(MazeCell.NORTH | MazeCell.SOUTH)] = ["───", "───"];
			tiles[(MazeCell.SOUTH)] = ["┘ └", "───"];
			tiles[(MazeCell.NORTH)] = ["───", "┐ ┌"];
			tiles[0] = ["┘ └", "┐ ┌"];
			
			var weave1:Array = ["┴─┴", "┬─┬"];
			var weave2:Array = ["┤ ├", "┤ ├"];
			
			var row:int, col:int;
			var mazeTrace:String = "\n";
			for (row = 0; row < maze.length; row++)
			{
				var isWeave1:Boolean = Math.random() < .5;
				for (col = 0; col < maze[0].length; col++)
					if (maze[row][col].weave)
						mazeTrace += isWeave1 ? weave1[0] : weave2[0];
					else if (tiles.hasOwnProperty(maze[row][col].walls))
						mazeTrace += tiles[maze[row][col].walls][0];
					else
						mazeTrace += maze[row][col].walls.toString(2);
				
				mazeTrace += "\n";
				for (col = 0; col < maze[0].length; col++)
					if (maze[row][col].weave)
						mazeTrace += isWeave1 ? weave1[1] : weave2[1];
					else if (tiles.hasOwnProperty(maze[row][col].walls))
						mazeTrace += tiles[maze[row][col].walls][1];
					else
						mazeTrace += maze[row][col].walls.toString(2);
				
				mazeTrace += "\n";
			}
			
			mazeTrace += "\n";
			trace(mazeTrace);
		}
	}

}

import flash.geom.Point;
import net.avdw.math.random.randomSign;

class MazeCell
{
	public static const NORTH:int = 1;
	public static const SOUTH:int = 1 << 1;
	public static const EAST:int = 1 << 2;
	public static const WEST:int = 1 << 3;
	
	public static const ALL_WALLS:int = NORTH | SOUTH | EAST | WEST;
	
	public var walls:int = ALL_WALLS;
	public var weave:Boolean = false;
	public var visited:Boolean = false;

}