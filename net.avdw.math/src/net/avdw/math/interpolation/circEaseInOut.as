package net.avdw.interpolation
{
	/**
	 *
	 * @param	p	number in the range [-1,1]
	 * @return
	 */
	public function circEaseInOut(p:Number):Number
	{
		return (p < .5) ? circEaseIn(p * 2) / 2 : circEaseIn(p * -2 + 2) / -2 + 1;
	}

}