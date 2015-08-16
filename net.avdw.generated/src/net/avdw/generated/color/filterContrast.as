package net.avdw.color
{
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * sets contrast value available are -100 ~ 100 @default is 0
	 * @param       value:int   contrast value
	 * @return      ColorMatrixFilter
	 */
	
	public function filterContrast(value:Number = 0):ColorMatrixFilter
	{
		value /= 100;
		var s:Number = value + 1;
		var o:Number = 128 * (1 - s);
		
		var m:Array = [
			s, 0, 0, 0, o,
			0, s, 0, 0, o,
			0, 0, s, 0, o,
			0, 0, 0, 1, 0
			];
		
		return new ColorMatrixFilter(m);
	}

}