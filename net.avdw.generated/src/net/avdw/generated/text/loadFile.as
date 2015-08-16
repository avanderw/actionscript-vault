package net.avdw.generated.text
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public function loadFile(file:*):String
	{
		if (file is File)
		{
			const fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			const contents:String = fileStream.readMultiByte(fileStream.bytesAvailable, "utf-8");
			fileStream.close();
			return contents;
		}
		else if (file is Class)
		{
			const bytes:ByteArray = new file() as ByteArray;
			return bytes.toString();
		}
		return null;
	}
}