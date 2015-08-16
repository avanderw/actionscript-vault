package net.avdw.generated.tilemap.tilemap
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Runner extends Sprite
	{
		private const WIDTH:int = 16;
		private const HEIGHT:int = 16;
		
		public function Runner()
		{
			//runTilemap();
			//runWorld();
			runBasicViewer();
			//Tilemap.MakeTemplate(16,16);
			//Tilemap.MakeTemplate(WIDTH, HEIGHT);
		}
		
		private function runBasicViewer():void {
			var tilemap:Tilemap = new Tilemap();
			var world:WorldData = new WorldData();
			addChild(new BasicViewer(tilemap, world));
			
			tilemap.load(new File(File.applicationDirectory.resolvePath("tilemap-template-"+WIDTH+"x"+HEIGHT+".png").nativePath));
			//world.load(new File(File.applicationDirectory.resolvePath("tilemap.csv").nativePath));
			//world.loadData(WorldGenerator.random(48, 32));
			world.loadData(WorldGenerator.perlin(48, 32));
		}
		
		private function runTilemap():void
		{
			var tilemap:Tilemap = new Tilemap();
			tilemap.loaded.add(function():void
				{
					trace("tilemap loaded");
				// tilemap.save();
				});
			tilemap.saved.add(function():void
				{
					trace("tilemap saved");
				});
			tilemap.load(new File(File.applicationDirectory.resolvePath("run.png").nativePath));
		}
		
		private function runWorld():void
		{
			var world:WorldData = new WorldData();
			world.loaded.add(function():void
				{
					trace("world loaded");
				// world.save();
				});
			world.saved.add(function():void
				{
					trace("world saved");
				});
			
			world.load(new File(File.applicationDirectory.resolvePath("tilemap.csv").nativePath));
		}
	
	}

}