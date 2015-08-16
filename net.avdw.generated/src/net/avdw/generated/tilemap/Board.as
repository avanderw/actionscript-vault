package net.avdw.generated.tilemap
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filters.DropShadowFilter;
	import net.avdw.pacman.WallLayer;
	import net.avdw.pattern.checkerboardTile;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Board extends Sprite
	{
		static public const ROWS:int = 21;
		static public const COLS:int = 19;
		static public const TILE_WIDTH:int = 24;
		static public const TILE_HEIGHT:int = 24;
		static public const WIDTH:int = COLS * TILE_WIDTH;
		static public const HEIGHT:int = (ROWS + 1) * TILE_HEIGHT;
		
		public function Board(match:Match)
		{
			if (match == null || match.states.length == 0)
				throw new Error("Invalid match setup");
			
			addChild(drawFloor());
			addChild(new Walls(match.currentState.data));
			addChild(new Pellets(match.currentState.data));
			addChild(new PowerPellets(match.currentState.data));
			addChild(match.pacmanA);
			addChild(match.pacmanB);
		}
		
		private function drawFloor():Shape
		{
			const shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginBitmapFill(checkerboardTile(TILE_WIDTH, 6));
			shape.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			shape.graphics.endFill();
			
			return shape;
		}
	
	}

}