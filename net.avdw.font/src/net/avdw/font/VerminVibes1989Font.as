package net.avdw.font
{
	import net.avdw.font.IFont;
	
	public class VerminVibes1989Font implements IFont
	{
		[Embed(
			source = "asset/VerminVibes1989Font.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "VerminVibes1989Font",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "VerminVibes1989Font";
		
		public function get name():String { return NAME; }
	}
}