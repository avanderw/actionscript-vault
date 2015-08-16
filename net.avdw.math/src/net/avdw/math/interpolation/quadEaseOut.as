package net.avdw.interpolation
{
	/**
	 *
	 * @param	p	number in the range [-1,1]
	 * @return
	 */
	public function quadEaseOut(p:Number):Number
	{
		return 1 - quadEaseIn(1 - p);
	}

}