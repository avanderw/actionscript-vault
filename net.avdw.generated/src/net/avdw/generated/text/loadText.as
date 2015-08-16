package net.avdw.text
{
	import flash.utils.ByteArray;
	
	public function loadText(FileToLoad:Class):String
	{
		var bytes:ByteArray = new FileToLoad() as ByteArray;
		return bytes.toString();
	}
}