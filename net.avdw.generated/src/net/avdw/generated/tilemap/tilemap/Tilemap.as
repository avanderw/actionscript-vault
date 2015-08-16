package net.avdw.generated.tilemap.tilemap
{
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Tilemap
	{
		static private const NUM_TILES:int = Math.pow(2, 9);
		static private const MIN_SQUARE:int = Math.ceil(Math.sqrt(NUM_TILES));
		
		private const clip:Rectangle = new Rectangle();
		private const _point:Point = new Point();
		
		private var file:File;
		private var lastModified:Date;
		
		public var data:BitmapData;
		public var loaded:Signal;
		public var saved:Signal;
		
		public function Tilemap()
		{
			loaded = new Signal();
			saved = new Signal();
			
			var refreshTimer:Timer = new Timer(1000);
			refreshTimer.addEventListener(TimerEvent.TIMER, function():void
				{
					if (file == null || !file.exists || lastModified == null)
						return;
					
					if (lastModified.time < file.modificationDate.time)
						load();
				});
			refreshTimer.start();
		}
		
		public function load(file:File = null):void
		{
			this.file = (file == null) ? this.file : file;
			
			if (this.file == null || !this.file.exists)
			{
				trace("tilemap file needs to be provided");
				return;
			}
			
			lastModified = this.file.modificationDate;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
				{
					data = new BitmapData(loader.width, loader.height, true, 0x0);
					data.draw(loader);
					loaded.dispatch();
				});
			loader.load(new URLRequest(this.file.url));
		}
		
		public function save():void
		{
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.CLOSE, function():void
				{
					lastModified = file.modificationDate;
					saved.dispatch();
				});
			
			stream.openAsync(file, FileMode.WRITE);
			stream.writeBytes(PNGEncoder.encode(data));
			stream.close();
		}
		
		public function rect(index:int):Rectangle
		{
			clip.width = tileWidth;
			clip.height = tileHeight;
			clip.x = (index % MIN_SQUARE) * tileWidth;
			clip.y = Math.floor(index / MIN_SQUARE) * tileHeight;
			
			return clip;
		}
		
		public function point(x:int, y:int):Point
		{
			_point.x = x * tileWidth;
			_point.y = y * tileHeight;
			
			return _point;
		}
		
		static public function MakeTemplate(tileWidth:int, tileHeight:int, callback:Function = null):void
		{
			var data:BitmapData = new BitmapData(tileWidth * MIN_SQUARE, tileHeight * MIN_SQUARE);
			
			var rect:Rectangle = new Rectangle(0, 0, tileWidth / 3, tileHeight / 3);
			var tileData:BitmapData = new BitmapData(tileWidth, tileHeight);
			var point:Point = new Point(), matrix:Matrix = new Matrix();
			
			for (var i:int = 0; i < NUM_TILES; i++)
			{
				tileData.fillRect(tileData.rect, 0x0);
				point.y = Math.floor(i / MIN_SQUARE) * tileHeight;
				point.x = (i % MIN_SQUARE) * tileWidth;
				
				var mask:int = 1;
				for (var j:int = 0; j < 9; j++)
				{
					rect.y = Math.floor(j / 3) * rect.height;
					rect.x = (j % 3) * rect.width;
					tileData.fillRect(rect, (i & mask) >> j == 1 ? 0xFF000000 : 0x0);
					
					// remove dangling diagonal points
					if ((i & 1) >> 0 == 1 && (i & 2) >> 1 == 0 && (i & 8) >> 3 == 0 && (i & 16) >> 4 == 0)
					{
						rect.y = 0;
						rect.x = 0;
						tileData.fillRect(rect, 0x0);
					}
					if ((i & 4) >> 2 == 1 && (i & 2) >> 1 == 0 && (i & 16) >> 4 == 0 && (i & 32) >> 5 == 0)
					{
						rect.y = 0;
						rect.x = rect.width * 2;
						tileData.fillRect(rect, 0x0);
					}
					if ((i & 64) >> 6 == 1 && (i & 8) >> 3 == 0 && (i & 16) >> 4 == 0 && (i & 128) >> 7 == 0)
					{
						rect.y = rect.height * 2;
						rect.x = 0;
						tileData.fillRect(rect, 0x0);
					}
					if ((i & 256) >> 8 == 1 && (i & 16) >> 4 == 0 && (i & 32) >> 5 == 0 && (i & 128) >> 7 == 0)
					{
						rect.y = rect.height * 2;
						rect.x = rect.width * 2;
						tileData.fillRect(rect, 0x0);
					}
					
					mask *= 2;
				}
				
				if ((i & 16) >> 4 == 1)
					tileData.fillRect(tileData.rect, 0xFF000000);
				
				data.copyPixels(tileData, tileData.rect, point);
			}
			
			var file:File = File.applicationDirectory;
			if (callback != null)
				file.addEventListener(Event.COMPLETE, callback);
			file.save(PNGEncoder.encode(data),"tilemap-template-" + tileWidth + "x" + tileHeight + ".png");
		}
		
		public function get exists():Boolean
		{
			return data != null;
		}
		
		public function get tileWidth():int
		{
			return data.width / MIN_SQUARE;
		}
		
		public function get tileHeight():int
		{
			return data.height / MIN_SQUARE;
		}
		
		public function get filename():String
		{
			return file.name;
		}
	}
}