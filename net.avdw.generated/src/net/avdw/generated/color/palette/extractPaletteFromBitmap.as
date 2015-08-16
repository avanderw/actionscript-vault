package net.avdw.generated.color.palette
{
	import com.adobe.utils.ArrayUtil;
	import flash.display.Bitmap;
	import net.avdw.array.arrayContains;
	
	public function extractPaletteFromBitmap(bitmap:Bitmap):Array
	{
		const colors:Array = [];
		for (var x:int = 0; x < bitmap.width; x++) {
			for (var y:int = 0; y < bitmap.height; y++) {
				if (colors.indexOf(bitmap.bitmapData.getPixel(x, y)) == -1) {
					colors.push(bitmap.bitmapData.getPixel(x, y));
				}
			}
		}
		
		return colors;
	}
}