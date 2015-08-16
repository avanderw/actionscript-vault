package net.avdw.generated.tilemap.autotile
{
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.filesystem.File;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TilesheetTester extends Sprite
	{
		public var showingNumberTilesheet:Boolean = false;
		public var color:uint = 0x857031;
		public var erase:Boolean = false;
		
		private var tilesheetFile:File;
		private var tilesheetLastModDate:Date;
		private var levelDataFile:File;
		private var levelDataLastModDate:Date;
		private var tilesheet:BitmapData;
		private var view:Bitmap;
		private var levelData:Vector.<Vector.<int>>;
		private var numberTilesheetLoader:Loader;
		private var numberTilesheet:File;
		private var previousTilesheet:BitmapData;
		private var highlightSquare:Sprite;
		private var scaledViewContainer:Sprite;
		private var mousePoint:Point = new Point();
		private var viewPoint:Point;
		private var gui:SimpleGUI;
		private var eraseCheckbox:CheckBox;
		private var showingNumberCheckbox:CheckBox;
		private var refreshTimer:Timer;
		private var statusLabel:Label;
		private var grid:Sprite = new Sprite();
		
		public function TilesheetTester()
		{
			if (stage)
				init()
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			gui = new SimpleGUI(this);
			gui.addButton("load test level", {callback: selectLevelCsv});
			gui.addButton("load tilesheet", {callback: selectTilesheet});
			gui.addColumn();
			gui.addButton("random level", {callback: randomiseTiledata});
			showingNumberCheckbox = gui.addToggle("showingNumberTilesheet", {label: "Show Numbers", callback: selectNumberTilesheet});
			gui.addColumn();
			gui.addColour("color", {callback: selectColor});
			eraseCheckbox = gui.addToggle("erase");
			gui.addColumn();
			gui.addButton("save", {callback: saveTilemap});
			statusLabel = gui.addLabel("status: saved");
			gui.show();
			
			refreshTimer = new Timer(1000);
			refreshTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
				{
					if (tilesheetFile != null && (tilesheetLastModDate == null || tilesheetFile.modificationDate.time > tilesheetLastModDate.time))
					{
						tilesheetLastModDate = tilesheetFile.modificationDate;
						tilesheetFile.dispatchEvent(new Event(Event.SELECT));
					}
					if (levelDataFile != null && (levelDataLastModDate == null || levelDataFile.modificationDate.time > levelDataLastModDate.time))
					{
						levelDataLastModDate = levelDataFile.modificationDate;
						levelDataFile.dispatchEvent(new Event(Event.SELECT));
					}
				});
			refreshTimer.start();
			
			highlightSquare = new Sprite();
			highlightSquare.graphics.beginFill(color);
			highlightSquare.graphics.drawRect(0, 0, 4, 4);
			highlightSquare.graphics.endFill();
			highlightSquare.visible = false;
			highlightSquare.mouseEnabled = false;
			
			stage.addEventListener(KeyboardEvent.KEY_UP, eraseShortcut);
			stage.addEventListener(KeyboardEvent.KEY_UP, saveShortcut);
			stage.addEventListener(KeyboardEvent.KEY_UP, numberViewShortcut);
			stage.addEventListener(KeyboardEvent.KEY_UP, fillCellShortcut);
		}
		
		private function fillCellShortcut(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.F && !showingNumberTilesheet)
			{
				var cell:Point = new Point(Math.floor((viewPoint.x + 2) / 16), Math.floor((viewPoint.y + 2) / 16));
				var index:int = valueat(cell.y, cell.x);
				var pixel:Point = new Point(viewPoint.x + 2 - cell.x * 16, viewPoint.y + 2 - cell.y * 16);
				
				tilesheet.fillRect(new Rectangle(0, index*16, 16, 16), erase ? 0x0 : (0xFF000000 | color));
				statusLabel.text = "STATUS: MODIFIED";
				refreshView();
			}
		}
		
		private function numberViewShortcut(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.R)
			{
				showingNumberTilesheet = !showingNumberTilesheet;
				showingNumberCheckbox.selected = showingNumberTilesheet;
				
				selectNumberTilesheet();
			}
		}
		
		private function saveShortcut(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.S)
			{
				saveTilemap();
			}
		}
		
		private function saveTilemap():void
		{
			refreshTimer.stop();
			var fileStream:FileStream = new FileStream();
			fileStream.open(tilesheetFile, FileMode.WRITE);
			fileStream.writeBytes(PNGEncoder.encode(tilesheet));
			fileStream.close();
			tilesheetLastModDate = tilesheetFile.modificationDate;
			refreshTimer.start();
			statusLabel.text = "STATUS: SAVED";
		}
		
		private function eraseShortcut(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.E)
			{
				erase = !erase;
				eraseCheckbox.selected = erase;
				
				selectColor();
			}
		}
		
		private function selectColor():void
		{
			if (!erase)
				highlightSquare.graphics.beginFill(color);
			else
				highlightSquare.graphics.beginFill(0xFFFFFF);
			
			highlightSquare.graphics.drawRect(0, 0, 4, 4);
			highlightSquare.graphics.endFill();
		}
		
		private function randomiseTiledata():void
		{
			var rowData:Vector.<int>;
			var x:int, y:int;
			levelData = new Vector.<Vector.<int>>();
			for (y = 0; y < 8; y++)
			{
				rowData = new Vector.<int>();
				for (x = 0; x < 8; x++)
				{
					rowData.push(Math.random() > 0.5 ? 0 : 1);
				}
				levelData.push(rowData); // should fire events just from updating
			}
			refreshView();
		}
		
		private function selectNumberTilesheet():void
		{
			if (!showingNumberTilesheet)
			{
				if (previousTilesheet == null)
				{
					selectTilesheet();
				}
				else
				{
					tilesheet = previousTilesheet;
					refreshView();
				}
				return;
			}
			if (numberTilesheetLoader == null)
			{
				var filter:FileFilter = new FileFilter("Numbered Tilesheet", "*.png");
				var file:File = File.applicationDirectory;
				file.addEventListener(Event.SELECT, function(e:Event):void
					{
						numberTilesheet = e.target as File;
						tilesheetLastModDate = numberTilesheet.modificationDate;
						
						numberTilesheetLoader = new Loader();
						numberTilesheetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
							{
								if (tilesheet != null)
									previousTilesheet = tilesheet.clone();
								tilesheet = new BitmapData(numberTilesheetLoader.width, numberTilesheetLoader.height, true, 0x0);
								tilesheet.draw(numberTilesheetLoader);
							});
						numberTilesheetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, refreshView);
						numberTilesheetLoader.load(new URLRequest(numberTilesheet.url));
					});
				file.browseForOpen("Tilesheet", [filter]);
			}
			else
			{
				numberTilesheetLoader.load(new URLRequest(numberTilesheet.url));
			}
		
		}
		
		private function selectTilesheet():void
		{
			var filter:FileFilter = new FileFilter("Tilesheet", "*.png");
			var file:File = File.applicationDirectory;
			file.addEventListener(Event.SELECT, function(e:Event):void
				{
					tilesheetFile = e.target as File;
					tilesheetLastModDate = tilesheetFile.modificationDate;
					
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
						{
							tilesheet = new BitmapData(loader.width, loader.height, true, 0x0);
							tilesheet.draw(loader);
						});
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, refreshView);
					loader.load(new URLRequest(tilesheetFile.url));
				});
			file.browseForOpen("Tilesheet", [filter]);
		}
		
		private function selectLevelCsv():void
		{
			var filter:FileFilter = new FileFilter("Level Data", "*.csv");
			var file:File = File.applicationDirectory;
			file.addEventListener(Event.COMPLETE, extractLevelData);
			file.addEventListener(Event.COMPLETE, refreshView);
			file.addEventListener(Event.SELECT, function(e:Event):void
				{
					levelDataFile = e.target as File;
					levelDataLastModDate = levelDataFile.modificationDate;
					levelDataFile.load();
				});
			file.browseForOpen("CSV", [filter]);
		}
		
		private function extractLevelData(e:Event):void
		{
			var file:File = e.target as File;
			
			levelData = new Vector.<Vector.<int>>();
			var rowData:Vector.<int> = new Vector.<int>();
			var char:String;
			while (file.data.position < file.data.length)
			{
				char = file.data.readUTFBytes(1);
				if (char.charCodeAt() == 13)
				{
					file.data.readUTFBytes(1);
					levelData.push(rowData);
					rowData = new Vector.<int>();
					continue;
				}
				if (char != ",")
				{
					rowData.push(char);
				}
			}
		}
		
		private function refreshView(e:Event = null):void
		{
			if (tilesheetFile == null || levelData == null)
			{
				return;
			}
			
			if (view == null)
			{
				view = new Bitmap(new BitmapData(levelData[0].length * 16, levelData.length * 16, true, 0x0));
				view.x = stage.stageWidth - view.width - 15;
				
				var scaledView:Bitmap = new Bitmap(view.bitmapData);
				scaledView.scaleX = scaledView.scaleY = 4;
				scaledViewContainer = new Sprite();
				scaledViewContainer.y = stage.stageHeight - scaledView.height - 15;
				scaledViewContainer.x = 10;
				scaledViewContainer.addEventListener(MouseEvent.MOUSE_OVER, showHighlight);
				scaledViewContainer.addEventListener(MouseEvent.MOUSE_MOVE, moveHighlight);
				scaledViewContainer.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void
					{
						scaledViewContainer.addEventListener(MouseEvent.MOUSE_MOVE, paintTilemap);
						paintTilemap();
					});
				scaledViewContainer.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void
					{
						scaledViewContainer.removeEventListener(MouseEvent.MOUSE_MOVE, paintTilemap);
					});
				scaledViewContainer.addChild(scaledView);
				grid.graphics.beginFill(0);
				for (y = 0; y <= levelData.length; y++)
				{
					grid.graphics.drawRect(0, y * 16 * 4, scaledViewContainer.width, 1);
				}
				for (x = 0; x <= levelData[0].length; x++)
				{
					grid.graphics.drawRect(x * 16 * 4, 0, 1, scaledViewContainer.height);
				}
				grid.graphics.endFill();
				scaledViewContainer.addChild(grid);
				
				addChild(scaledViewContainer);
				addChild(view);
			}
			
			const point:Point = new Point();
			const clipRect:Rectangle = new Rectangle(0, 0, 16, 16);
			view.bitmapData.lock();
			for (y = 0; y < levelData.length; y++)
			{
				for (x = 0; x < levelData[y].length; x++)
				{
					point.y = y * 16;
					point.x = x * 16;
					clipRect.y = valueat(y, x) * 16;
					view.bitmapData.copyPixels(tilesheet, clipRect, point);
				}
			}
			view.bitmapData.unlock();
			
			addChild(highlightSquare);
		}
		
		private function paintTilemap(e:MouseEvent = null):void
		{
			if (!showingNumberTilesheet)
			{
				var cell:Point = new Point(Math.floor((viewPoint.x + 2) / 16), Math.floor((viewPoint.y + 2) / 16));
				var index:int = valueat(cell.y, cell.x);
				var pixel:Point = new Point(viewPoint.x + 2 - cell.x * 16, viewPoint.y + 2 - cell.y * 16);
				
				tilesheet.setPixel32(pixel.x, index * 16 + pixel.y, erase ? 0x0 : (0xFF000000 | color));
				statusLabel.text = "STATUS: MODIFIED";
				refreshView();
			}
		}
		
		private function valueat(y:int, x:int):int
		{
			var value:int = 0;
			value += ((y == 0 || x == 0) ? 0 : (levelData[y - 1][x - 1] == 1) ? 1 : 0);
			value += ((y == 0) ? 0 : (levelData[y - 1][x] == 1) ? 2 : 0);
			value += ((y == 0 || x == levelData[y].length - 1) ? 0 : (levelData[y - 1][x + 1] == 1) ? 4 : 0);
			value += ((x == 0) ? 0 : (levelData[y][x - 1] == 1) ? 8 : 0);
			value += ((levelData[y][x] == 1) ? 16 : 0);
			value += ((x == levelData[y].length - 1) ? 0 : (levelData[y][x + 1] == 1) ? 32 : 0);
			value += ((y == levelData.length - 1 || x == 0) ? 0 : (levelData[y + 1][x - 1] == 1) ? 64 : 0);
			value += ((y == levelData.length - 1) ? 0 : (levelData[y + 1][x] == 1) ? 128 : 0);
			value += ((y == levelData.length - 1 || x == levelData[y].length - 1) ? 0 : (levelData[y + 1][x + 1] == 1) ? 256 : 0);
			
			return value;
		}
		
		private function showHighlight(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_OVER, showHighlight);
			e.target.addEventListener(MouseEvent.MOUSE_OUT, hideHighlight);
			
			highlightSquare.visible = true;
		}
		
		private function hideHighlight(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, hideHighlight);
			e.target.addEventListener(MouseEvent.MOUSE_OVER, showHighlight);
			
			highlightSquare.visible = false;
		}
		
		private function moveHighlight(e:MouseEvent):void
		{
			if (scaledViewContainer != null)
			{
				mousePoint.x = mouseX;
				mousePoint.y = mouseY;
				var point:Point = scaledViewContainer.globalToLocal(mousePoint);
				point.x = Math.floor(point.x / 4) * 4 + 1;
				point.y = Math.floor(point.y / 4) * 4 + 1;
				viewPoint = new Point(Math.floor(point.x / 4), Math.floor(point.y / 4));
				point = scaledViewContainer.localToGlobal(point);
				highlightSquare.x = point.x;
				highlightSquare.y = point.y;
			}
		
		}
	
	}

}