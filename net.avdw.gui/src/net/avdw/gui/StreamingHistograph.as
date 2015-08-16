package net.avdw.gui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import net.avdw.align.alignHorizontalRightTo;
	import net.avdw.demo.ADemo;
	import net.avdw.display.addChildrenTo;
	import net.avdw.ds.HistogramDs;
	import net.avdw.ds.SortedArrayDs;
	import net.avdw.font.FontConsolas;
	import net.avdw.stats.QuantileEstimationGK;
	import net.avdw.stats.rollingMean;
	import net.avdw.math.Range;
	import net.avdw.math.sum;
	import net.avdw.stats.RollingStats;
	import net.avdw.text.embeddedFont;
	import net.avdw.tracepoint;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class StreamingHistograph extends Sprite
	{
		private const nf:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);
		private const approxSampleStatisticsText:TextField = new TextField();
		private const approxSampleStatisticsStr:String = "samples: {samples}"
		+ "\nmean: {mean}"
		+ "\nstddev: {stddev}";
		
		private const fiveNumSummaryText:TextField = new TextField();
		private const fiveNumSummaryStr:String = "min: {min}" 
		+ "\nlower fence: {lfence}" 
		+ "\nlower quartile: {lquart}" 
		+ "\nmedian: {median}" 
		+ "\nupper quartile: {uquart}" 
		+ "\nupper fence: {ufence}"
		+ "\nmax: {max}";
		
		private const rollingStats:RollingStats = new RollingStats();
		
		private var graphWidth:int;
		private var graphHeight:int;
		private var histogram:HistogramDs;
		private var quantiles:QuantileEstimationGK = new QuantileEstimationGK(0.01, 7);
		private var sampleCount:uint = 0;
		private var heightDiv4:int;
		private var heightDiv2:int;
		private var heightDiv3Over4:int;
		
		public function StreamingHistograph(name:String, expectedRange:Range, width:int = 600, data:Array = null)
		{
			this.name = name;
			this.graphWidth = width;
			histogram = new HistogramDs(expectedRange, width);
			
			const nameText:TextField = embeddedFont(name, FontConsolas.NAME, 10);
			nameText.x = (width - nameText.width) / 2;
			graphHeight = 6 * nameText.textHeight + nameText.height;
			heightDiv4 = graphHeight * .25;
			heightDiv2 = graphHeight * .5;
			heightDiv3Over4 = graphHeight * .75;
			
			approxSampleStatisticsText.y = 2 * nameText.textHeight;
			approxSampleStatisticsText.autoSize = TextFieldAutoSize.LEFT;
			approxSampleStatisticsText.embedFonts = true;
			approxSampleStatisticsText.selectable = false;
			approxSampleStatisticsText.defaultTextFormat = nameText.defaultTextFormat;
			
			fiveNumSummaryText.autoSize = TextFieldAutoSize.LEFT;
			fiveNumSummaryText.embedFonts = true;
			fiveNumSummaryText.selectable = false;
			fiveNumSummaryText.defaultTextFormat = new TextFormat(FontConsolas.NAME, 10, null, null, null, null, null, null, TextFormatAlign.RIGHT);
			
			addChildrenTo(this, nameText, approxSampleStatisticsText, fiveNumSummaryText);
			
			refresh();
		}
		
		public function add(element:Number):void {
			histogram.add(element);
			rollingStats.push(element);
			quantiles.insert(element);
			sampleCount++;
		}
		
		public function refresh():void
		{	
			// border
			graphics.clear();
			graphics.lineStyle(1, 0xAAAAAA);
			graphics.beginFill(0xEEEEEE);
			graphics.drawRect(0, 0, graphWidth, graphHeight);
			graphics.endFill();
			
			if (sampleCount == 0)
				return;
				
			var lquart:Number = quantiles.query(.25);
			var median:Number = quantiles.query(.5);
			var uquart:Number = quantiles.query(.75);
			var interQr:Number = uquart - lquart;
			var lfence:Number = lquart - 1.58 * interQr;
			var ufence:Number = uquart + 1.58 * interQr;
			
			// data
			graphics.lineStyle(1, 0xCCCCCC);
			for (var xCount:int = 0; xCount < graphWidth; xCount++) {
				graphics.moveTo(xCount, graphHeight);
				graphics.lineTo(xCount, graphHeight - histogram.bins[xCount] / histogram.maxBinCount * graphHeight);
			}
			
			var xCountMean:Number = Math.floor((rollingStats.mean - histogram.expectedRange.lower) / histogram.binSize);
			var xCountLQuart:Number = Math.floor((lquart - histogram.expectedRange.lower) / histogram.binSize);
			var xCountUQuart:Number = Math.ceil((uquart - histogram.expectedRange.lower) / histogram.binSize);
			var xCountLFence:Number = Math.floor((Math.max(lfence, histogram.actualRange.lower) - histogram.expectedRange.lower)  / histogram.binSize);
			var xCountUFence:Number = Math.ceil((Math.min(ufence, histogram.actualRange.upper) - histogram.expectedRange.lower)  / histogram.binSize);
			
			// stddev
			graphics.lineStyle(1, 0xAAAAAA);
			var xCountStdDev:Number = Math.floor(rollingStats.stddev / histogram.binSize);
			for (var i:int = 1; i < 4; i++) {
				graphics.moveTo(Math.max(0, Math.floor(xCountMean - i * xCountStdDev)), graphHeight);
				graphics.lineTo(Math.max(0, Math.floor(xCountMean - i * xCountStdDev)), 0);
				graphics.moveTo(Math.min(graphWidth, Math.ceil(xCountMean + i * xCountStdDev)), graphHeight);
				graphics.lineTo(Math.min(graphWidth, Math.ceil(xCountMean + i * xCountStdDev)), 0);
			}
			
			// boxplot
			graphics.lineStyle(1, 0x888888);
			graphics.moveTo(xCountMean, graphHeight);
			graphics.lineTo(xCountMean, 0);
			graphics.drawRect(xCountLQuart, heightDiv4, xCountUQuart - xCountLQuart, heightDiv2);
			graphics.moveTo(xCountLFence, heightDiv4);
			graphics.lineTo(xCountLFence, heightDiv3Over4);
			graphics.moveTo(xCountUFence, heightDiv4);
			graphics.lineTo(xCountUFence, heightDiv3Over4);
			graphics.moveTo(xCountLFence, heightDiv2);
			graphics.lineTo(xCountLQuart, heightDiv2);
			graphics.moveTo(xCountUQuart, heightDiv2);
			graphics.lineTo(xCountUFence, heightDiv2);
			
			
			approxSampleStatisticsText.text = approxSampleStatisticsStr
			.replace("{samples}", sampleCount)
			.replace("{mean}", nf.formatNumber(rollingStats.mean))
			.replace("{stddev}", nf.formatNumber(rollingStats.stddev));
			
			fiveNumSummaryText.text = fiveNumSummaryStr
			.replace("{min}", nf.formatNumber(histogram.actualRange.lower))
			.replace("{lfence}", nf.formatNumber(lfence))
			.replace("{lquart}", nf.formatNumber(lquart))
			.replace("{median}", nf.formatNumber(median))
			.replace("{uquart}", nf.formatNumber(uquart))
			.replace("{ufence}", nf.formatNumber(ufence))
			.replace("{max}", nf.formatNumber(histogram.actualRange.upper));
			
			fiveNumSummaryText.x = graphWidth - fiveNumSummaryText.width;
		}
	}
}