package net.avdw.color
{
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * sets saturation value available are -100 ~ 100 @default is 0
	 * @param       value:int   saturation value
	 * @return      ColorMatrixFilter
	 */
	
	public function filterSaturation(value:Number = 0):ColorMatrixFilter
	{
		const lumaR:Number = 0.212671;
		const lumaG:Number = 0.71516;
		const lumaB:Number = 0.072169;
		
		var v:Number = value / 100 + 1;
		var i = 1 - v;
		var r = i * lumaR;
		var g = i * lumaG;
		var b = i * lumaB;
		
		var m:Array = [
			r + v, g, b, 0, 0,
			r, g + v, b, 0, 0,
			r, g, b + v, 0, 0,
			0, 0, 0, 1, 0
		];
		
		return new ColorMatrixFilter(m);
	}

}