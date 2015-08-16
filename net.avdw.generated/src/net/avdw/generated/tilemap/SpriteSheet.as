package net.avdw.generated.tilemap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.avdw.color.convertHEXtoARGB;
	import net.avdw.color.filterToColor;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Spritesheet
	{
		public var sheetData:BitmapData;
		private var spriteWidth:int;
		private var spriteHeight:int;
		
		public const whenLoaded:Signal = new Signal();
		
		public function Spritesheet(file:File, spriteWidth:int, spriteHeight:int)
		{
			this.spriteHeight = spriteHeight;
			this.spriteWidth = spriteWidth;
			
			new BitmapLoader(file, function(bitmap:Bitmap):void
				{
					sheetData = bitmap.bitmapData;
					whenLoaded.dispatch();
				});
		}
		
		public function tint(hex:uint):void
		{
			const argb:Object = convertHEXtoARGB(hex);
			sheetData.colorTransform(sheetData.rect, new ColorTransform(argb.r, argb.g, argb.b));
		}
		
		/**
		 *
		 * @param	row		0-based
		 * @param	frames
		 * @return
		 */
		public function createAnimation(row:int, frames:int):BitmapAnimation
		{
			const animationData:Vector.<BitmapData> = new Vector.<BitmapData>;
			const y:int = row * spriteHeight;
			
			for (var x:int = 0; x < frames * spriteWidth; x += spriteWidth)
			{
				const frameData:BitmapData = new BitmapData(spriteWidth, spriteHeight, true, 0);
				const copyRect:Rectangle = new Rectangle(x, y, spriteWidth, spriteHeight);
				frameData.copyPixels(sheetData, copyRect, new Point);
				animationData.push(frameData);
			}
			
			return new BitmapAnimation(animationData);
		}
	}
}