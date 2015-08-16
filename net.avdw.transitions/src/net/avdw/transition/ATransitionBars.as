package net.avdw.transition
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ATransitionBars
	{
		
		public function ATransitionBars()
		{
		}
		
		protected function createMasks(bars:Vector.<Bitmap>):Vector.<Bitmap>
		{
			const masks:Vector.<Bitmap> = new Vector.<Bitmap>();
			for each (var bar:Bitmap in bars)
			{
				const mask:Bitmap = new Bitmap(new BitmapData(bar.width, bar.height, false, 0));
				mask.x = bar.x;
				mask.y = bar.y;
				masks.push(mask);
			}
			return masks;
		}
		
		protected function addResources(container:DisplayObjectContainer, bars:Vector.<Bitmap>, masks:Vector.<Bitmap>):void
		{
			for (var i:int = 0; i < bars.length; i++)
			{
				container.addChild(masks[i]);
				container.addChild(bars[i]);
				
				bars[i].mask = masks[i];
			}
		}
		
		protected function onCompleteTransition(bars:Vector.<Bitmap>, masks:Vector.<Bitmap>, snapshot:Bitmap):void
		{
			for each (var mask:Bitmap in masks)
			{
				mask.bitmapData.dispose();
				mask.parent.removeChild(mask);
			}
			masks.splice(0, masks.length);
			
			for each (var bar:Bitmap in bars)
			{
				bar.bitmapData.dispose();
				bar.parent.removeChild(bar);
			}
			bars.splice(0, bars.length);
			
			snapshot.bitmapData.dispose();
		}
	}
}