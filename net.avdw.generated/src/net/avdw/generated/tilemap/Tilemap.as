package net.avdw.generated.tilemap
{
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * TODO write test case for different tilemap configurations
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Tilemap extends Bitmap
	{
		
		public function Tilemap(tilemap:BitmapData, state:Array, tileWidth:int, tileHeight:int, matchTile:*)
		{
			bitmapData = new BitmapData(state[0].length * tileWidth, state.length * tileHeight, true, 0);
			const tilesPerRow:int = tilemap.width / tileWidth;
			for (var row:int = 0; row < state.length; row++)
				for (var col:int = 0; col < state[row].length; col++)
					switch (state[row][col])
				{
					case matchTile: 
						const index:int = calculateTileIndex(state, row, col, matchTile);
						const tilemapRow:int = Math.floor(index / tilesPerRow);
						const tilemapCol:int = index % tilesPerRow;
						const sourceRect:Rectangle = new Rectangle(tilemapCol * tileWidth, tilemapRow * tileHeight, tileWidth, tileHeight);
						const destPoint:Point = new Point(col * tileWidth, row * tileHeight);
						bitmapData.copyPixels(tilemap, sourceRect, destPoint);
						break;
				}
		}
		
		private function calculateTileIndex(data:Array, row:int, col:int, match:*):int
		{
			var index:int = 0;
			if (row - 1 >= 0)
				index += data[row - 1][col] == match ? 1 : 0;
			if (col - 1 >= 0)
				index += data[row][col - 1] == match ? 2 : 0;
			if (col + 1 < data[row].length)
				index += data[row][col + 1] == match ? 4 : 0;
			if (row + 1 < data.length)
				index += data[row + 1][col] == match ? 8 : 0;
			return index;
		}
		
		static public function generateTemplate(tileWidth:int, tileHeight:int):void
		{
			const numTiles:int = Math.pow(2, 4);
			const rows:int = Math.ceil(Math.sqrt(numTiles));
			const cols:int = rows;
			const bmpData:BitmapData = new BitmapData(cols * tileWidth, rows * tileHeight);
			const stamp:Bitmap = new Bitmap(new BitmapData(3, 3, false));
			stamp.scaleX = tileWidth / 3;
			stamp.scaleY = tileHeight / 3;
			
			var darken:Boolean = false;
			for (var idx:int = 0; idx < numTiles; idx++, darken = !darken)
			{
				stamp.bitmapData.fillRect(stamp.bitmapData.rect, darken ? 0xCCCCCC : 0xFFFFFF);
				stamp.bitmapData.setPixel(1, 1, 0);
				if ((idx & 1) >> 0 == 1)
					stamp.bitmapData.setPixel(1, 0, 0);
				if ((idx & 2) >> 1 == 1)
					stamp.bitmapData.setPixel(0, 1, 0);
				if ((idx & 4) >> 2 == 1)
					stamp.bitmapData.setPixel(2, 1, 0);
				if ((idx & 8) >> 3 == 1)
					stamp.bitmapData.setPixel(1, 2, 0);
				
				bmpData.draw(stamp, new Matrix(stamp.scaleX, 0, 0, stamp.scaleY, stamp.x, stamp.y));
				stamp.x += tileWidth;
				if (stamp.x >= bmpData.width)
				{
					darken = !darken;
					stamp.x = 0;
					stamp.y += tileHeight;
				}
			}
			var file:File = File.applicationDirectory;
			file.browseForSave("tilemap-4bit-" + tileWidth + "x" + tileHeight + ".png");
			file.addEventListener(Event.SELECT, function():void
				{
					var stream:FileStream = new FileStream();
					stream.openAsync(file, FileMode.WRITE);
					stream.writeBytes(PNGEncoder.encode(bmpData));
					stream.close();
				});
		}
	}

}