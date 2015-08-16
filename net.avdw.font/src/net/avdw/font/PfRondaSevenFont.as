package net.avdw.font
{
	import net.avdw.font.IFont;
	public class PfRondaSevenFont implements IFont
	{
		[Embed(
			source = "asset/PfRondaSevenFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "PfRondaSevenFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "PfRondaSevenFont";
		
		public function get name():String { return NAME; }
	}
}