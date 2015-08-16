package net.avdw.generated.render
{
	import flash.display.BitmapData;
	import net.avdw.color.convertARGBtoHEX;
	
	public function renderGrayscaleHeightmap(map:Vector.<Vector.<Number>>):BitmapData
	{
		var height:int = map.length;
		var width:int = map[0].length;
		
		var bmpData:BitmapData = new BitmapData(map[0].length, map.length, false, 0);
		for (var y:int = 0; y < height; y++)
			for (var x:int = 0; x < width; x++)
				bmpData.setPixel(x, y, convertARGBtoHEX(1, map[y][x], map[y][x], map[y][x]));
		
		return bmpData;
	}
}