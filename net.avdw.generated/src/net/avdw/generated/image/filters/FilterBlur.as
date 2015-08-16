package net.avdw.generated.image.filters
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class FilterBlur
	{
		public function FilterBlur()
		{
		
		}
		
		public static function create(target:*, sourceBitmapData:BitmapData = null, sourceRect:Rectangle = null, destPoint:Point = null):BitmapData
		{
			var destBitmapData:BitmapData;
			if (target is Bitmap)
			{
				destBitmapData = (target as Bitmap).bitmapData.clone();
			}
			else if (target is BitmapData)
			{
				destBitmapData = target;
			}
			
			const weight:int = 7;
			var blurFilter:Array = guassianKernel(weight, 4);
			
			destBitmapData = (destBitmapData == null) ? sourceBitmapData.clone() : destBitmapData;
			sourceBitmapData = (sourceBitmapData == null) ? destBitmapData : sourceBitmapData;
			sourceRect = (sourceRect == null) ? sourceBitmapData.rect : sourceRect;
			destPoint = (destPoint == null) ? new Point() : destPoint;
			
			destBitmapData.applyFilter(sourceBitmapData, sourceRect, destPoint, new ConvolutionFilter(weight, weight, blurFilter));
			
			return destBitmapData;
		}
		
		public static function guassianKernel(size:int, sigmaSqr:Number):Array
		{
			var x:int;
			var y:int;
			var g:Number;
			
			var kernel:Array = [];
			var mid:int = size / 2;
			var sum:Number = 0;
			
			for (x = 0; x < size; x++)
			{
				kernel[x] = [];
				for (y = 0; y < size; y++)
				{
					if (x > mid && y < mid)
						g = kernel[size - x - 1][y];
					else if (x < mid && y > mid)
						g = kernel[x][size - y - 1];
					else if (x > mid && y > mid)
						g = kernel[size - x - 1][size - y - 1];
					else
						g = gauss(x - mid, y - mid, sigmaSqr);
					
					kernel[x][y] = g;
					sum += g;
				}
			}
			
			var matrix:Array = [];
			// Normalize the kernel
			for (x = 0; x < size; ++x)
				for (y = 0; y < size; ++y)
					matrix.push(kernel[x][y] / sum);
			
			return matrix;
		}
		
		public static function gauss(x:int, y:int, sigmaSqr:Number):Number
		{
			var pow:Number = Math.pow(Math.E, -((x * x + y * y) / (2 * sigmaSqr)));
			var g:Number = (1 / (Math.sqrt(2 * Math.PI * sigmaSqr))) * pow;
			return g;
		}
	}
}