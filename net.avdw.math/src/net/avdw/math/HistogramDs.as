package net.avdw.ds
{
	import net.avdw.math.Range;
	
	public class HistogramDs
	{
		public var expectedRange:Range;
		public var actualRange:Range;
		public var bins:Vector.<Number>;
		public var maxBinCount:uint = 1;
		public var binSize:Number;
		
		public function HistogramDs(expectedRange:Range, numberBins:uint)
		{
			this.expectedRange = expectedRange;
			actualRange = Range.closed(.5, .5);
			
			binSize = expectedRange.size / numberBins;
			bins = new Vector.<Number>;
			for (var i:int = 0; i < numberBins; i++)
				bins.push(0);
		}
		
		public function add(number:Number):void
		{
			if (number < actualRange.lower)
				actualRange.lower = number;
			
			if (number > actualRange.upper)
				actualRange.upper = number;
			
			var binIdx:int = Math.floor((number - expectedRange.lower) / binSize) ;
			if (binIdx < bins.length && binIdx > 0 && ++bins[binIdx] > maxBinCount)
				maxBinCount = bins[binIdx];
		}
	}
}