package net.avdw.generated.wallpaper
{
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	public function drawStamp(width:int, height:int, stamp:Bitmap, round:int = 0):Shape
	{
		const canvas:Shape = new Shape();
		canvas.graphics.beginBitmapFill(stamp.bitmapData);
		if (round == 0)
			canvas.graphics.drawRect(0, 0, width, height);
		else
			canvas.graphics.drawRoundRect(0, 0, width, height, round);
		canvas.graphics.endFill();
		return canvas;
	}

}