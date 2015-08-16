package net.avdw.interpolation
{
	/**
	 *
	 * @param	p	number in the range [-1,1]
	 * @return
	 */
	public function sineEaseIn(p:Number):Number
	{
		return 1 - Math.cos(p * Math.PI / 2);
	}

}