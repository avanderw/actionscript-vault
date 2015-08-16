package net.avdw.interpolation
{
	/**
	 *
	 * @param	p	number in the range [-1,1]
	 * @return
	 */
	public function sineEaseInOut(p:Number):Number
	{
		return (p < .5) ? sineEaseIn(p * 2) / 2 : sineEaseIn(p * -2 + 2) / -2 + 1;
	}

}