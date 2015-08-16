package net.avdw.font
{
	import net.avdw.font.IFont;
	
	public class EarlyGameBoyFont implements IFont
	{
		[Embed(
			source = "asset/EarlyGameBoyFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "EarlyGameBoyFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "EarlyGameBoyFont";
		
		public function get name():String { return NAME; }
	}
}