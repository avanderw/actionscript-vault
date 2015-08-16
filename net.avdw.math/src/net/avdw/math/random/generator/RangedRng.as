package net.avdw.math.random.generator 
{
	import net.avdw.math.Range;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RangedRng 
	{
		private var rng:ARng;
		private var range:Range;
		
		public function RangedRng(range:Range, rng:ARng) 
		{
			this.range = range;
			this.rng = rng;
		}
		
		override public function random():Number
		{
			return rng.float(range.lower, range.upper);
		}
		
		override public function reset():ARng
		{
			rng.reset();
			return this;
		}
	}

}