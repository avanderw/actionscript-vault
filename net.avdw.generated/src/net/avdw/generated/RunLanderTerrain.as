package net.avdw.generated 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RunLanderTerrain extends Sprite
	{
		private var terrainData:BitmapData;
		
		public function RunLanderTerrain() 
		{
			addEventListener(Event.ENTER_FRAME, startup);
		}
		
		private function startup(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, startup);
			stage.addEventListener(MouseEvent.CLICK, generate);
			
			terrainData = new BitmapData(40, 30, false);
			
			var terrainView:Bitmap = new Bitmap(terrainData);
			terrainView.scaleX = terrainView.scaleY = 16;
			
			addChild(terrainView);
			generate();
		}
		
		private function generate(e:MouseEvent = null):void 
		{
			var row:int, col:int;
			terrainData.perlinNoise(20, 20, 8, Math.random() * int.MAX_VALUE, false, true, 7, true);
			for (row = 0; row < terrainData.height; row++) {
				for (col = 0; col < terrainData.width; col++) {
					if (terrainData.getPixel(col, row) < 0x676767)
						terrainData.setPixel(col, row, 0);
					else 
						terrainData.setPixel(col, row, 0xFFFFFF);
				}
			}
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(terrainData.width, terrainData.height, -Math.PI/2);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0, 0xFFFFFF], [1, 1], [0, 255], matrix); 
			shape.graphics.drawRect(0, 0, terrainData.width, terrainData.height);
			shape.graphics.endFill();
			
			var gradient:BitmapData = new BitmapData(terrainData.width, terrainData.height);
			gradient.draw(shape);
			
			terrainData.applyFilter(terrainData, terrainData.rect, new Point, new DisplacementMapFilter(gradient, new Point, 0, 
			1, 0, .1));
		}
	}

}