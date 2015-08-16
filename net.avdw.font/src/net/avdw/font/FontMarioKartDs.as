package net.avdw.font
{
	import flash.text.TextField;
	
	public class FontMarioKartDs
	{
		[Embed(
			source = "asset/MarioKartDsFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "FontMarioKartDs",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static private const fontClass:Class;
		
		static public function createTextfied(text:String, size:int = 12, color:uint = 0):TextField {
			return createEmbeddedTextfield("FontMarioKartDs", text, size, color);
		}
	}
}