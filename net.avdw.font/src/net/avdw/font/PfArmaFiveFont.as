package net.avdw.font
{
	import net.avdw.font.IFont;
	public class PfArmaFiveFont implements IFont
	{
		[Embed(
			source = "asset/PfArmaFiveFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "PfArmaFiveFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "PfArmaFiveFont";
		
		public function get name():String { return NAME; }
	}
}