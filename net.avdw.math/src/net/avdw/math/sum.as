package net.avdw.math
{
	public function sum(elements:Array):Number
	{
		var total:Number = 0;
		for each (var element:* in elements)
			total += element;
			
		return total;
	}
}