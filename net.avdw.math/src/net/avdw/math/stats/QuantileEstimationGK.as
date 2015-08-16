package net.avdw.stats
{
	
	/**
	 * https://github.com/umbrant/QuantileEstimation
	 * Greenwald and Khanna. "Space-efficient online computation of quantile summaries" in SIGMOD 2001.
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class QuantileEstimationGK
	{
		private const samples:Vector.<Item> = new Vector.<Item>;
		
		private var compactSize:int;
		private var epsilon:Number;
		private var count:int = 0;
		
		public function QuantileEstimationGK(epsilon:Number, compactSize:int)
		{
			this.epsilon = epsilon;
			this.compactSize = compactSize;
		}
		
		public function insert(v:Number):void
		{
			var idx:int = 0;
			for each (var item:Item in samples)
			{
				if (item.value > v)
					break;
				
				idx++;
			}
			
			var delta:Number;
			if (idx == 0 || idx == samples.length)
				delta = 0;
			else
				delta = Math.floor(2 * epsilon * count);
			
			var newItem:Item = new Item(v, 1, delta);
			samples.splice(idx, 0, newItem);
			
			if (samples.length > compactSize)
				compress();
			
			count++;
		}
		
		private function compress():void
		{
			var removed:int = 0;
			for (var i:int = 0; i < samples.length - 1; i++)
			{
				// merge items together if we don't need to maintain the error bound
				if (samples[i].g + samples[i + 1].g + samples[i + 1].delta <= Math.floor(2 * epsilon * count))
				{
					samples[i + 1].g += samples[i].g;
					samples.splice(i, 1);
					removed++;
				}
			}
		}
		
		public function query(quantile:Number):Number
		{
			if (samples.length == 0)
				return NaN;
		
			var rankMin:int = 0;
			var desired:int = quantile * count;
			
			for (var i:int = 1; i < samples.length; i++)
			{
				var prev:Item = samples[i - 1];
				var curr:Item = samples[i];
				
				rankMin += prev.g;
				
				if (rankMin + curr.g + curr.delta > desired + (2 * epsilon * count))
				{
					return prev.value;
				}
			}
			
			// edge case of wanting the max value
			return samples[samples.length - 1].value;
		}
	}
}

class Item
{
	public var delta:Number;
	public var g:Number;
	public var value:Number;
	
	public function Item(value:Number, lowerDelta:Number, delta:Number)
	{
		this.value = value;
		this.g = lowerDelta;
		this.delta = delta;
	}
	
	public function toString():String
	{
		return value + ", " + g + ", " + delta;
	}
}