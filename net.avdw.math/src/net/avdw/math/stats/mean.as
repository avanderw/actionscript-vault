package net.avdw.stats
{
	import net.avdw.math.sum;
	
	public function mean(array:Array):Number
	{
		return sum(array) / array.length;
	}
}