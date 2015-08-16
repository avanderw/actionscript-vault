package net.avdw.generated.tilemap.tilemap
{
	import com.bit101.components.Label;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class BasicViewer extends Sprite
	{
		private const bitmap:Bitmap = new Bitmap();
		private const grid:Sprite = new Sprite();
		
		private var tilemap:Tilemap;
		private var worldData:WorldData;
		private var bitmapData:BitmapData;
		
		public function BasicViewer(tilemap:Tilemap, worldData:WorldData)
		{
			this.worldData = worldData;
			this.tilemap = tilemap;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.CLICK, function():void {
				if (grid != null) {
					grid.visible = !grid.visible;
				}
			});
			
			if (worldData.exists && tilemap.exists)
				refresh();
			
			worldData.loaded.add(refresh);
			tilemap.loaded.add(refresh);
			
			addChild(bitmap);
			addChild(grid);
		}
		
		private function refresh():void
		{
			if (!worldData.exists || !tilemap.exists)
				return;
			
			if (bitmapData != null)
				bitmapData.dispose();
			
			bitmapData = new BitmapData(worldData.width * tilemap.tileWidth, worldData.height * tilemap.tileHeight);
			bitmap.bitmapData = bitmapData;
			
			bitmapData.lock();
			for (var y:int = 0; y < worldData.height; y++)
				for (var x:int = 0; x < worldData.width; x++)
					bitmapData.copyPixels(tilemap.data, tilemap.rect(worldData.index(x, y)), tilemap.point(x, y));
			bitmapData.unlock();
			
			grid.graphics.clear();
			grid.graphics.beginFill(0x333333);
			for (y = 0; y <= worldData.height; y++)
				grid.graphics.drawRect(0, y * tilemap.tileHeight, bitmapData.width, 1);
			for (x = 0; x <= worldData.width; x++)
				grid.graphics.drawRect(x * tilemap.tileWidth, 0, 1, bitmapData.height);
			grid.graphics.endFill();
		}
	
	}

}