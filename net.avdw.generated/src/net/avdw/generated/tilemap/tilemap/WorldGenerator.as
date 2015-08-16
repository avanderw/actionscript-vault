package net.avdw.generated.tilemap.tilemap
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class WorldGenerator
	{
		
		public function WorldGenerator()
		{
		
		}
		
		static private function generate(width:int, height:int, func:Function):Vector.<Vector.<int>> {
			var data:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			var x:int, y:int, rowData:Vector.<int>;
			for (y = 0; y < height; y++) {
				rowData = new Vector.<int>();
				for (x = 0; x < width; x++) {
					rowData.push(func.apply(null, [x, y]));
				}
				data.push(rowData);
			}
			return data;
		}
		
		static public function random(width:int, height:int):Vector.<Vector.<int>>
		{
			var func:Function = function(x:int, y:int):int {
				return Math.round(Math.random());
			}
			return generate(width, height, func);
		}
		
		static public function perlin(width:int, height:int):Vector.<Vector.<int>>
		{
			var data:BitmapData = new BitmapData(width, height);
			data.perlinNoise(width, height, 8, Math.random() * int.MAX_VALUE, false, false, 7, true);
			
			var func:Function = function(x:int, y:int):int {
				return (data.getPixel(x, y) >> 16 > 0x44 ? 1: 0);
			}
			return generate(width, height, func);
		}
	}

}