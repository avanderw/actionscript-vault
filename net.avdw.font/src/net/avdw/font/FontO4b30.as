package net.avdw.font
{
	import flash.text.TextField;
	
	public class FontO4b30
	{
		[Embed(
			source = "asset/O4b30Font.ttf",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "O4b30Font",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
		)]
		static private const fontClass:Class;
		
		static public function createTextfied(text:String, size:int = 12, color:uint = 0):TextField {
			return createEmbeddedTextfield("O4b30Font", text, size, color);
		}
	}

}