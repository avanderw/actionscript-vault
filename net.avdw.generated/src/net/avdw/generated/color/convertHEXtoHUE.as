package net.avdw.color
{
	public function convertHEXtoHUE(color:uint):uint
	{
		var c:Object = convertHEXtoARGB(color);
		return convertRGBtoHUE(c.r, c.g, c.b);
	}
}