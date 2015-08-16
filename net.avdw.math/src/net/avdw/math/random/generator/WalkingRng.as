package net.avdw.math.random.generator 
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class WalkingRng extends ARng
	{
		protected var rng:ARng;
		protected var start:Number;
		protected var walkingNumber:Number;
		
		public function WalkingRng(start:Number, rng:ARng) 
		{
			this.start = start;
			this.rng = rng;
		}
		
		override public function random():Number
		{
			return walkingNumber += rng.sign() * rng.random();
		}
		
		override public function reset():ARng
		{
			rng.reset();
			walkingNumber = start;
			return this;
		}
		
	}

}