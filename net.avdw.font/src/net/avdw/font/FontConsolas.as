package net.avdw.font 
{
	import flash.text.TextField;
	
	public class FontConsolas
	{
		[Embed(
			source = "asset/ConsolasFont.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "FontConsolas",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static private const fontClass:Class;
		
		static public function createTextfied(text:String, size:int = 12, color:uint = 0):TextField {
			return createEmbeddedTextfield("FontConsolas", text, size, color);
		}
	}
}