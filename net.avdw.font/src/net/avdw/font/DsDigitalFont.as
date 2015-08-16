package net.avdw.font 
{
	import net.avdw.font.IFont;
	public class DsDigitalFont implements IFont
	{
		[Embed(
			source = "asset/DsDigitalFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "DsDigitalFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "DsDigitalFont";
		
		public function get name():String { return NAME; }
	}
}