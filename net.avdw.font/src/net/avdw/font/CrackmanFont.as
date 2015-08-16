package net.avdw.font 
{
	import net.avdw.font.IFont;
	
	public class CrackmanFont implements IFont
	{
		[Embed(
			source = "asset/CrackmanFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "CrackmanFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "CrackmanFont";
		
		public function get name():String { return NAME; }
	}
}