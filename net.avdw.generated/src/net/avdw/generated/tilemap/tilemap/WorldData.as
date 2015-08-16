package net.avdw.generated.tilemap.tilemap
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class WorldData
	{
		private var file:File;
		private var data:Vector.<Vector.<int>>;
		private var lastModified:Date;
		
		public var loaded:Signal;
		public var saved:Signal;
		
		public function WorldData()
		{
			loaded = new Signal();
			saved = new Signal();
			
			var refreshTimer:Timer = new Timer(1000);
			refreshTimer.addEventListener(TimerEvent.TIMER, function():void
				{
					if (file == null || !file.exists)
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
				trace("world file needs to be provided");
				return;
			}
			
			lastModified = this.file.modificationDate;
			
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.COMPLETE, function():void
				{
					var csv:String = stream.readUTFBytes(stream.bytesAvailable);
					stream.close();
					
					data = new Vector.<Vector.<int>>();
					var rowData:Vector.<int> = new Vector.<int>();
					var i:int, num:String = "";
					for (i = 0; i < csv.length; i++)
					{
						if (csv.charCodeAt(i) == 13) // CarriageReturn
							continue;
						
						if (csv.charCodeAt(i) == 10) // LineFeed
						{
							rowData.push(num);
							num = "";
							
							data.push(rowData);
							rowData = new Vector.<int>();
							
							continue;
						}
						
						if (csv.charAt(i) == ",")
						{
							rowData.push(num);
							num = "";
						}
						else
						{
							num += csv.charAt(i);
						}
					}
					
					if (rowData.length != 0)
					{
						rowData.push(num);
						data.push(rowData);
					}
					
					loaded.dispatch();
				});
			stream.openAsync(this.file, FileMode.READ);
		}
		
		public function save():void
		{
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.CLOSE, function():void
				{
					lastModified = file.modificationDate;
					saved.dispatch();
				});
			
			var csv:String = "", y:int, x:int;
			for (y = 0; y < data.length; y++)
			{
				for (x = 0; x < data[y].length; x++)
				{
					csv += data[y][x] + ",";
				}
				csv = csv.substr(0, csv.length - 1) + "\n";
			}
			csv = csv.substr(0, csv.length - 1);
			
			stream.openAsync(file, FileMode.WRITE);
			stream.writeUTFBytes(csv);
			stream.close();
		}
		
		public function loadData(data:Vector.<Vector.<int>>):void
		{
			this.data = data;
			loaded.dispatch();
		}
		
		public function index(x:int, y:int):int
		{
			var value:int = 0;
			
			value += ((y == 0 || x == 0) ? 0 : (data[y - 1][x - 1] != 0) ? 1 : 0);
			value += ((y == 0) ? 0 : (data[y - 1][x] != 0) ? 2 : 0);
			value += ((y == 0 || x == width - 1) ? 0 : (data[y - 1][x + 1] != 0) ? 4 : 0);
			value += ((x == 0) ? 0 : (data[y][x - 1] != 0) ? 8 : 0);
			value += ((data[y][x] != 0) ? 16 : 0);
			value += ((x == width - 1) ? 0 : (data[y][x + 1] != 0) ? 32 : 0);
			value += ((y == height - 1 || x == 0) ? 0 : (data[y + 1][x - 1] != 0) ? 64 : 0);
			value += ((y == height - 1) ? 0 : (data[y + 1][x] != 0) ? 128 : 0);
			value += ((y == height - 1 || x == width - 1) ? 0 : (data[y + 1][x + 1] != 0) ? 256 : 0);
			
			return value;
		}
		
		public function get exists():Boolean
		{
			return data != null;
		}
		
		public function get height():int
		{
			return (data != null) ? data.length : 0;
		}
		
		public function get width():int
		{
			return (data != null && data.length > 0) ? data[0].length : 0;
		}
		
		public function get filename():String
		{
			return file.name;
		}
	}

}