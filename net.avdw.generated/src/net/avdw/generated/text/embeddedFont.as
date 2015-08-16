package net.avdw.generated.text
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.avdw.font.IFont;
	
	/**
	 * 
	 * @param	text
	 * @param	font	IFont / String name
	 * @param	size
	 * @param	color
	 * @return
	 */
	public function embeddedFont(text:String, font:*, size:int = 0, color:uint = 0):TextField
	{
		var fontName:String;
		var fontSize:int;
		if (font is IFont) {
			fontName = font.name;
			fontSize = size == 0 ? font.size : size;
		} else if (font is String) {
			fontName = font;
			fontSize = size;
		}
		
		var textField:TextField = new TextField();
		textField.embedFonts = true;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.defaultTextFormat = new TextFormat(fontName, fontSize, color);
		textField.text = text;
		textField.selectable = false;
		return textField;
	}
}