package net.avdw.generated.tilemap
{
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	
	public class WallTile extends Sprite
	{
		static public var WIDTH:int;
		static public var HEIGHT:int;
		static public var DATA:BitmapData;
		
		public var index:int;
		public var row:int;
		public var col:int;
		
		public function WallTile(index:int)
		{
			this.index = index;
		}
		
		public function setRowCol(row:int, col:int):void
		{
			this.row = row;
			this.col = col;
			refresh();
		}
		
		public function refresh():void
		{
			if (DATA == null)
				return;
			
			if (WIDTH == 0 || HEIGHT == 0)
			{
				throw new Error();
			}
			
			graphics.clear();
			
			graphics.beginBitmapFill(DATA, new Matrix(1, 0, 0, 1, 0, index * -HEIGHT));
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			
			y = row * HEIGHT;
			x = col * WIDTH;
		}
		
		static public function identifyIndex(state:Array, row:int, col:int):int
		{
			
		}
		
		static public function generateTemplate():void
		{
			const numTiles:int = Math.pow(2, 4);
			const rows:int = numTiles;
			const cols:int = 1;
			const bmpData:BitmapData = new BitmapData(cols * WIDTH, rows * HEIGHT);
			const stamp:Bitmap = new Bitmap(new BitmapData(3, 3, false));
			stamp.scaleX = WIDTH / 3;
			stamp.scaleY = HEIGHT / 3;
			
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
				
				bmpData.draw(stamp, new Matrix(stamp.scaleX, 0, 0, stamp.scaleY, 0, stamp.y));
				stamp.x += WIDTH;
				if (stamp.x >= bmpData.width)
				{
					stamp.x = 0;
					stamp.y += WallTile.HEIGHT;
				}
			}
			var file:File = File.applicationDirectory;
			file.browseForSave("tilemap-4bit-" + WIDTH + "x" + HEIGHT + ".png");
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