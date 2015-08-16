package net.avdw.font
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public function createEmbeddedTextfield(font:String, text:String, size:int = 12, color:uint = 0):TextField
	{
		var textField:TextField = new TextField();
		textField.embedFonts = true;
		textField.autoSize = TextFieldAutoSize.LEFT;
		textField.defaultTextFormat = new TextFormat(font, size, color);
		textField.text = text;
		textField.selectable = false;
		return textField;
	}
}