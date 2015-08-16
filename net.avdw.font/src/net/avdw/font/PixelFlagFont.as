package net.avdw.font
{
	import net.avdw.font.IFont;
	
	public class PixelFlagFont implements IFont
	{
		[Embed(
			source = "asset/PixelFlagFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "PixelFlagFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "PixelFlagFont";
		
		public function get name():String { return NAME; }
	}
}