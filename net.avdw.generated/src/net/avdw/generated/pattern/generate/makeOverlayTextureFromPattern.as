package net.avdw.generated.pattern.generate
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.BitmapData;
	
	// TODO remove this as it is not worth it for now
	public function makeOverlayTextureFromPattern(bmpData:BitmapData, width:int, height:int = 0):Shape
	{
		var shape:Shape = makeTextureFromPattern(bmpData, width, height);
		shape.blendMode = BlendMode.OVERLAY;
		return shape;
	}
}