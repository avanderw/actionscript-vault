package net.avdw.color
{
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * sets brightness value available are -100 ~ 100 @default is 0
	 * @param       value:int   brightness value
	 * @return      ColorMatrixFilter
	 */
	
	public function filterBrightness(value:Number = 0):ColorMatrixFilter
	{
		value *= 255 / 250;
		var m:Array = [
			1, 0, 0, 0, value,
			0, 1, 0, 0, value,
			0, 0, 1, 0, value,
			0, 0, 0, 1, 0
		];
		
		return new ColorMatrixFilter(m);
	}

}