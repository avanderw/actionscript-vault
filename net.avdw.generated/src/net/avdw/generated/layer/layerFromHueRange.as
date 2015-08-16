package net.avdw.generated.layer
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.avdw.color.convertHSLtoHEX;
	import net.avdw.math.Range;
	
	public function layerFromHueRange(width:uint, height:uint, range:Range):BitmapData
	{
		const bitmapData:BitmapData = new BitmapData(width, height);
		const drawRectangle:Rectangle = new Rectangle(0, 0, width / range.size, height);
		for (var i:int = range.lower; i < range.upper; i++)
		{
			bitmapData.fillRect(drawRectangle, convertHSLtoHEX(i, .5, .5));
			drawRectangle.x += drawRectangle.width;
		}
		return bitmapData;
	}
}