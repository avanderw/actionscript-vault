package net.avdw.font 
{
	import net.avdw.font.IFont;
	public class DroidSansMonoFont implements IFont
	{
		[Embed(
			source = "asset/DroidSansMonoFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "DroidSansMonoFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "DroidSansMonoFont";
		
		public function get name():String { return NAME; }
	}
}