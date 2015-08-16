package net.avdw.font
{
	import flash.text.Font;
	import flash.text.TextField;
	
	public class FontFipps
	{
		[Embed(
			source = "asset/FippsFont.otf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "FippsFont",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static private const fontClass:Class;
		
		static public function createTextfied(text:String, size:int = 12, color:uint = 0):TextField {
			return createEmbeddedTextfield("FippsFont", text, size, color);
		}
	}

}