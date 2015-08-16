package net.avdw.generated.color.palette 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class PaletteDawnBringer16Bit 
	{
		[Embed(source = "dawnbringer/16bit.png")]
		static public const PALETTE_IMAGE:Class;
		
		static public const BLACK:uint = 0x140c1c;
		static public const BLUE:uint = 0x597dce;
		static public const PURPLE:uint = 0x442434;
		static public const ORANGE:uint = 0xd27d2c;
		static public const DARK_BLUE:uint = 0x30346d;
		static public const LIGHT_GRAY:uint = 0x8595a1;
		static public const DARK_GRAY:uint = 0x4e4a4e;
		static public const LIGHT_GREEN:uint = 0x6daa2c;
		static public const DARK_ORANGE:uint = 0x854c30;
		static public const LIGHT_RED:uint = 0xd2aa99;
		static public const DARK_GREEN:uint = 0x346524;
		static public const LIGHT_BLUE:uint = 0x6dc2ca;
		static public const RED:uint = 0xd04648;
		static public const LIGHT_YELLOW:uint = 0xdad45e;
		static public const GRAY:uint = 0x757161;
		static public const WHITE:uint = 0xdeeed6;
		
		static public const ALL_COLORS:Array = extractPaletteFromBitmap(new PALETTE_IMAGE);
		
		public function PaletteDawnBringer16Bit() 
		{
			
		}	
		
		static public function generateSamplePalette():Sprite {
			const sampleSprite:Sprite = new Sprite;
			var idx:int = 0;
			for each (var color:uint in ALL_COLORS) {
				sampleSprite.graphics.beginFill(color);
				sampleSprite.graphics.drawRect(0, idx * 20, 100, 20);
				sampleSprite.graphics.endFill();
				idx++;
			}
			return sampleSprite
		}
	}
}