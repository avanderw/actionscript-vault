package net.avdw.font
{
	import net.avdw.font.IFont;
	
	public class EditUndoLinefont implements IFont
	{
		[Embed(
			source = "asset/EditUndoLinefont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "EditUndoLinefont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static public const FONT:Class;
		static public const NAME:String = "EditUndoLinefont";
		
		public function get name():String { return NAME; }
	}
}