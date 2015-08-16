package net.avdw.generated.image
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GeneratedMosaic
	{
		
		public function GeneratedMosaic()
		{
		
		}
		
		public static function generateOverlay(width:int, height:int = 0, mosaicSize:int = 3, strength:Number = 1):Shape {
			var highlight:uint = 0xFF7F7F7F + 0x7F7F7F * strength;
			var darken:uint = 0xFF7F7F7F - 0x7F7F7F * strength;
			var shape:Shape = generateShape(generate(mosaicSize, highlight, darken), width, height);
			shape.blendMode = BlendMode.OVERLAY;
			return shape;
		}
		
		// TODO change name to explicitly state overlay colors
		// TODO change colors to strength value
		// TODO take width & height params here
		// TODO return shape with overlay setting
		public static function generate(size:int = 3, c1:uint = 0xFFFFFFFF, c2:uint = 0xFF000000):BitmapData
		{
			var arr:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>;
			var x:int, y:int, idx:int;
			for (x = 0; x < size; x++)
			{
				var row:Vector.<uint> = new Vector.<uint>();
				for (y = 0; y < size; y++)
				{
					row.push(0xFF7F7F7F);
				}
				arr.push(row);
			}
			
			arr[0][0] = c1;
			arr[size - 1][size - 1] = c2;
			
			for (var i:int = 1; i < size - 1; i++)
			{
				arr[i][0] = c1;
				arr[i][size - 1] = c2;
			}
			
			for (i = 1; i < size - 1; i++)
			{
				arr[0][i] = c1;
				arr[size - 1][i] = c2;
			}
			
			return generateTexture(arr);
		}
		
		public static function generateTexture(pattern:Vector.<Vector.<uint>>):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(pattern[0].length, pattern.length, true, 0);
			for (var y:int = 0; y < bmpData.height; y++)
				for (var x:int = 0; x < bmpData.width; x++)
					bmpData.setPixel32(x, y, pattern[y][x]);
			
			return bmpData;
		}
		
		public static function generateShape(texture:BitmapData, width:int, height:int = 0):Shape
		{
			height = height == 0 ? width : height;
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(texture);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			return shape;
		}
	}
}
