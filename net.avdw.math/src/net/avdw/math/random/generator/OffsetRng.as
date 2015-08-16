package net.avdw.math.random.generator 
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class OffsetRng extends ARng
	{
		private var rng:ARng;
		private var base:Number;
		
		public function OffsetRng(base:Number, rng:ARng) 
		{
			this.base = base;
			this.rng = rng;
		}
		
		override public function random():Number
		{
			return base + rng.sign() * rng.random();
		}
		
		override public function reset():ARng
		{
			rng.reset();
			return this;
		}
		
	}

}