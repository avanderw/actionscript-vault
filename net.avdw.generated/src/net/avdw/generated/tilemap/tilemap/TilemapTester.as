package net.avdw.generated.tilemap.tilemap
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TilemapTester extends Sprite
	{
		static private const tilemap:Tilemap = new Tilemap();
		static private const worldData:WorldData = new WorldData();
		static private const viewer:BasicViewer = new BasicViewer(tilemap, worldData);
		static private const generationFunctions:Array = [ { label:"random", data:WorldGenerator.random }, { label:"perlin", data:WorldGenerator.perlin } ];
		static private const tilemapFileFilter:Array = [new FileFilter("tilemap", "*.png")];
		
		private var gui:SimpleGUI;
		
		public var tileWidth:int = 16;
		public var tileHeight:int = 16;
		public var worldWidth:int = 48;
		public var worldHeight:int = 26;
		public var generationFunction:Function;
		
		public function TilemapTester()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(viewer);
			
			gui = new SimpleGUI(this);
			gui.addGroup("tilemap");
			gui.addStepper("tileWidth", 0, 1024);
			gui.addStepper("tileHeight", 0, 1024);
			gui.addButton("generate", { callback:function():void {
				Tilemap.MakeTemplate(tileWidth, tileHeight, function(e:Event):void {
					tilemap.load(e.target as File);
				});
			}});
			gui.addButton("load", { callback:function():void {
				var file:File = File.applicationDirectory;
				file.addEventListener(Event.SELECT, function():void {
					tilemap.load(file);
				});
				file.browseForOpen("tilemap", tilemapFileFilter);
			}});
			gui.addButton("save");
			
			gui.addColumn("world data");
			gui.addStepper("worldWidth", 0, 1024);
			gui.addStepper("worldHeight", 0, 1024);
			gui.addComboBox("generationFunction", generationFunctions);
			gui.addButton("generate", { callback:function():void {
				if (generationFunction == null) {
					return;
				}
				worldData.loadData(generationFunction(worldWidth, worldHeight));
			}});
			gui.addButton("load");
			gui.addButton("save");
			
			gui.show();
			
			tilemap.loaded.add(resize);
			worldData.loaded.add(resize);
			
			tilemap.load(new File(File.applicationDirectory.resolvePath("tilemap-template-16x16.png").nativePath));
		}
		
		private function resize():void 
		{
			tileHeight = tilemap.tileHeight;
			tileWidth = tilemap.tileWidth;
			gui.update();
			
			viewer.x = 5;
			viewer.y = stage.stageHeight - 5 - worldHeight*tileHeight;
		}
	
	}

}