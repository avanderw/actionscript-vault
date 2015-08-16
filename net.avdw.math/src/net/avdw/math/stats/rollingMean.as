package net.avdw.stats
{
	
	public function rollingMean(mean:Number, newSample:Number, newSampleSize:uint):Number
	{
		mean -= mean / newSampleSize;
		return mean += newSample / newSampleSize;
	}

}