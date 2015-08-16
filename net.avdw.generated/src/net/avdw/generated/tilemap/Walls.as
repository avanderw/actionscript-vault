package net.avdw.generated.tilemap
{
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Walls extends Bitmap
	{
		static public const tilemapFile:File = File.applicationDirectory.resolvePath("image/tilemap-24x24-4bit-arrangement.png");
		static public const WALL_CHAR:String = "#";
		
		public function Walls(stateData:Array)
		{
			new BitmapLoader(tilemapFile, function(wallBitmap:Bitmap):void
				{
					bitmapData = new Tilemap(wallBitmap.bitmapData, stateData, Board.TILE_WIDTH, Board.TILE_HEIGHT, WALL_CHAR).bitmapData;
					y -= 4;
					filters = [new DropShadowFilter()];
				});
		}
	
	}

}