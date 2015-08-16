package net.avdw.random
{	
	public function randomOffsetFrom(baseNumber:Number, minOffset:Number, maxOffset:Number = NaN, inBothDirections:Boolean = true):Number
	{
		if (inBothDirections)
		{
			return baseNumber + randomSign() * randomNumber(minOffset, maxOffset);
		}
		else
		{
			return baseNumber + randomNumber(minOffset, maxOffset);
		}
	}
}