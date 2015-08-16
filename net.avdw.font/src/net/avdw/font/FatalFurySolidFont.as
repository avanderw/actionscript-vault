package net.avdw.font
{
	import net.avdw.font.IFont;
	
	public class FatalFurySolidFont implements IFont
	{
		[Embed(
			source = "asset/FatalFurySolidFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "FatalFurySolidFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "FatalFurySolidFont";
		
		public function get name():String { return NAME; }
	}
}