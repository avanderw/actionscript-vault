package net.avdw.generated.layer
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public function layerFromRadialGradient(width:int, height:int, colors:Array = null, ratios:Array = null):Sprite
	{
		if (colors == null)
			colors = [0x666666, 0x0];
		
		var i:int;
		var alphas:Array = [];
		for (i = 0; i < colors.length; i++)
			alphas[i] = 1;
		
		if (ratios == null)
		{
			ratios = [];
			for (i = 0; i < colors.length; i++)
				ratios[i] = i / (colors.length - 1) * 0xFF;
		}
		
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(width * 2, height * 2, 0, -width / 2, -height / 2);
		
		var bg:Sprite = new Sprite();
		bg.name = "net.avdw.background.bgRadialGradient";
		bg.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
		bg.graphics.drawRect(0, 0, width, height);
		bg.graphics.endFill();
		
		return bg;
	}
}