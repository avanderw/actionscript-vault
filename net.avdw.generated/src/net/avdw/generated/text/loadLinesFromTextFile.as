package net.avdw.text
{
	import flash.utils.ByteArray;
	
	public function loadLinesFromTextFile(FileToLoad:Class):Array
	{
		var bytes:ByteArray = new FileToLoad() as ByteArray;
		return bytes.toString().split("\n");
	}
}