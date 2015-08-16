package net.avdw.stats
{
	
	/**
	 * http://www.johndcook.com/skewness_kurtosis.html
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RollingStats
	{
		private var n:uint;
		private var M1:Number, M2:Number, M3:Number, M4:Number;
		
		public function RollingStats()
		{
			clear();
		}
		
		public function clear():void
		{
			n = 0;
			M1 = M2 = M3 = M4 = 0;
		}
		
		public function push(x:Number):void
		{
			var delta:Number, deltaByN:Number, deltaByNSqr:Number, term1:Number;
			var oldSampleSize:Number = n;
			
			n++;
			delta = x - M1;
			deltaByN = delta / n;
			deltaByNSqr = deltaByN * deltaByN;
			term1 = delta * deltaByN * oldSampleSize;
			M1 += deltaByN;
			M4 += term1 * deltaByNSqr * (n * n - 3 * n + 3) + 6 * deltaByNSqr * M2 - 4 * deltaByN * M3;
			M3 += term1 * deltaByN * (n - 2) - 3 * deltaByN * M2;
			M2 += term1;
		}
		
		public function get mean():Number
		{
			return M1;
		}
		
		public function get variance():Number
		{
			return n == 1 ? 0 : M2 / (n - 1);
		}
		
		public function get stddev():Number
		{
			return Math.sqrt(variance);
		}
		
		public function get skewness():Number
		{
			return Math.sqrt(n) * M3 / Math.pow(M2, 1.5);
		}
		
		public function get kurtosis():Number
		{
			return n * M4 / (M2 * M2) - 3.0;
		}
		
		public function plus(stats:RollingStats):RollingStats
		{
			var combined:RollingStats = new RollingStats;
			combined.n = this.n + stats.n;
			
			var delta:Number = stats.M1 - M1;
			var delta2:Number = delta * delta;
			var delta3:Number = delta * delta2;
			var delta4:Number = delta2 * delta2;
			
			combined.M1 = (this.n * this.M1 + stats.n * stats.M1) / combined.n;
			
			combined.M2 = this.M2 + stats.M2 + delta2 * this.n * stats.n / combined.n;
			
			combined.M3 = this.M3 + stats.M3 + delta3 * this.n * stats.n * (this.n - stats.n) / (combined.n * combined.n);
			combined.M3 += 3.0 * delta * (this.n * stats.M2 - stats.n * this.M2) / combined.n;
			
			combined.M4 = this.M4 + stats.M4 + delta4 * this.n * stats.n * (this.n * this.n - this.n * stats.n + stats.n * stats.n) / (combined.n * combined.n * combined.n);
			combined.M4 += 6.0 * delta2 * (this.n * this.n * stats.M2 + stats.n * stats.n * this.M2) / (combined.n * combined.n) + 4.0 * delta * (this.n * stats.M3 - stats.n * this.M3) / combined.n;
			
			return combined;
		}
	}

}