package net.avdw.stats
{
	public function variance(array:Array):Number
	{
		var m:Number = mean(array);
		var avg:Number = 0;
		for each (var num:Number in array)
		{
			avg += Math.pow(m - num, 2);
		}
		return avg / array.length;
	}

}