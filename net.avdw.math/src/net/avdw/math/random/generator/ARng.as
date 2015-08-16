package net.avdw.math.random.generator
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ARng
	{
		public function ARng()
		{
			//throw new Error(this + " is an abstract class");
		}
		
		/**
		 * @return Returns a number in the range [0,1)
		 */
		public function random():Number
		{
			throw new Error("Method should be overriden");
		}
		
		/**
		 * Resets the number generator
		 * @return
		 */
		public function reset():ARng
		{
			throw new Error("Method should be overriden");
		}
		
		/**
		 * Marsaglia transform
		 * http://en.wikipedia.org/wiki/Marsaglia_polar_method
		 * http://blog.controul.com/2009/04/standard-normal-distribution-in-as3/
		 * @return A number from the standard normal distribution
		 */
		private var useCache:Boolean = true;
		private var cache:Number = 0;
		final public function stdNormal():Number
		{
			useCache = !useCache;
			if (useCache)
				return cache;
				
			var x:Number, y:Number, w:Number;
			do 
			{
				x = float( -1, 1);
				y = float( -1, 1);
				w = x * x + y * y;
			}
			while (w >= 1 || w == 0);
			
			w = Math.sqrt( -2 * Math.log(w) / w);
			cache = x * w;
			return y * w;
		}
		
		/**
		 * Returns a number that fits the gaussian parameters
		 * @param	mean
		 * @param	stddev
		 * @return 	A number fitting the gaussian parameters
		 */
		final public function gaussian(mean:Number, stddev:Number):Number {
			return mean + stdNormal() * stddev;
		}
		
		/**
		 * Returns a number in the range [0, min) or [min, max)
		 * @param	min
		 * @param	max
		 * @return	A number in the specified range
		 */
		final public function float(min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			return random() * (max - min) + min;
		}
		
		/**
		 * Returns true chance percent of the time, false otherwise
		 * @param	chance
		 */
		final public function boolean(chance:Number = .5):Boolean
		{
			return (random() < chance);
		}
		
		/**
		 * Returns 1 chance percent of the time, -1 otherwise
		 * @param	chance
		 * @return
		 */
		public function sign(chance:Number = .5):int
		{
			return (random() < chance) ? 1 : -1;
		}
		
		/**
		 * Returns 1 chance percent of the time, 0 otherwise
		 * @param	chance
		 * @return
		 */
		public function bit(chance:Number = .5):int
		{
			return (random() < chance) ? 1 : 0;
		}
		
		/**
		 * Returns an integer in the range [0, min) or [min, max)
		 * @param	min
		 * @param	max
		 * @return
		 */
		public function integer(min:Number, max:Number = NaN):int
		{
			return Math.floor(float(min, max));
		}
	
	}

}