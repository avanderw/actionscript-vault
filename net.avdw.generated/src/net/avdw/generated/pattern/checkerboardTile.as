package net.avdw.generated.pattern
{
	import flash.display.BitmapData;
	import net.avdw.number.isEven;
	import net.avdw.number.isOdd;
	
	public function checkerboardTile(tileSize:uint = 32, numSquares:int = 4):BitmapData
	{
		const color1:uint = 0x212121;
		const color2:uint = 0x606060;
		const color3:uint = 0x9C9C9C;
		const color4:uint = 0xDEDEDE;
		
		const bitmapData:BitmapData = new BitmapData(tileSize, tileSize, false, 0xFFFFFF);
		var x:int, y:int, numSquares:int = tileSize / numSquares;
		var colorX:int, colorY:int;
		for (y = 0; y < tileSize; y++)
		{
			for (x = 0; x < tileSize; x++)
			{
				colorX = Math.floor(x / numSquares);
				colorY = Math.floor(y / numSquares);
				if ((y == tileSize-1 && x == 0) || (y==0 && x == tileSize-1)) 
					bitmapData.setPixel(x, y, color2);
				else if (y==tileSize-1 && x==tileSize-1)
					bitmapData.setPixel(x, y, color1);
				else if (y == 0)
					bitmapData.setPixel(x, y, isEven(colorX) ? color4 : color3);
				else if (y == tileSize - 1)
					bitmapData.setPixel(x, y, isEven(colorX) ? color1 : color2);
				else if (x == 0)
					bitmapData.setPixel(x, y, isEven(colorY) ? color4 : color3);
				else if (x == tileSize - 1)
					bitmapData.setPixel(x, y, isEven(colorY) ? color1 : color2);
				else
					bitmapData.setPixel(x, y, ((isEven(colorX) && isOdd(colorY)) || (isOdd(colorX) && isEven(colorY))) ? color2 : color3);
			}
		}
		
		return bitmapData;
	}
}