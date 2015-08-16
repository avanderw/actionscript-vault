package net.avdw.stats
{
	public function stddev(array:Array):Number
	{
		return Math.sqrt(variance(array));
	}
}