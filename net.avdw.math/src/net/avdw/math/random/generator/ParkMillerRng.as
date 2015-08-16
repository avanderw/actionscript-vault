package net.avdw.math.random.generator
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ParkMillerRng extends ARng
	{
		/* The original seed used by this number generator */
		protected var seed:uint;
		protected var walkingNumber:uint;
		
		/**
		 * Setups the random number generator given a seed.
		 * If no seed is provided then a random seed is selected.
		 * @param	seed
		 */
		public function ParkMillerRng(seed:uint = 0)
		{
			if (seed == 0)
				seed = uint.MAX_VALUE * Math.random();
			
			walkingNumber = this.seed = seed;
		}
		
		override public function random():Number
		{
			return (walkingNumber = (walkingNumber * 16807) % 2147483647) / 0x7FFFFFFF + 0.000000000233;
		}
		
		override public function reset():ARng
		{
			walkingNumber = seed;
			return this;
		}
	}
}