package net.avdw.generated.image.filters
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FilterGrayscale
	{
		
		public function FilterGrayscale()
		{
		
		}
		
		public static function create(target:*, sourceBitmapData:BitmapData = null, sourceRect:Rectangle = null, destPoint:Point = null):BitmapData
		{	
			var destBitmapData:BitmapData;
			if (target is Bitmap) {
				destBitmapData = (target as Bitmap).bitmapData.clone();
			} else if (target is BitmapData) {
				destBitmapData = target;
			}
			
			const grayFilter:Array = [
				0.3, 0.59, 0.11, 0, 0,
				0.3, 0.59, 0.11, 0, 0,
				0.3, 0.59, 0.11, 0, 0,
				  0,    0,    0, 1, 0
			];
			
			destBitmapData = (destBitmapData == null) ? sourceBitmapData.clone() : destBitmapData;
			sourceBitmapData = (sourceBitmapData == null) ? destBitmapData : sourceBitmapData;
			sourceRect = (sourceRect == null) ? sourceBitmapData.rect : sourceRect;
			destPoint = (destPoint == null) ? new Point() : destPoint;
			
			destBitmapData.applyFilter(sourceBitmapData, sourceRect, destPoint, new ColorMatrixFilter(grayFilter));
			return destBitmapData;
		}
	
	}

}