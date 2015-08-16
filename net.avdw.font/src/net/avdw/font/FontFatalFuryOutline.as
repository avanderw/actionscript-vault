package net.avdw.font
{
	import flash.text.TextField;
	
	public class FontFatalFuryOutline
	{
		[Embed(
			source = "asset/FatalFuryOutlineFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "FatalFuryOutlineFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static private const fontClass:Class;
		
		static public function createTextfied(text:String, size:int = 12, color:uint = 0):TextField {
			return createEmbeddedTextfield("FatalFuryOutlineFont", text, size, color);
		}
	}
}