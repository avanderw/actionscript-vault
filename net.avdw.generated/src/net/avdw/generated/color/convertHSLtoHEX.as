package net.avdw.color
{
	public function convertHSLtoHEX(hue:Number, saturation:Number, luminance:Number):uint
	{
		const rgb:Object = convertHSLtoRGB(hue, saturation, luminance);
		return convertARGBtoHEX(1, rgb.r, rgb.g, rgb.b);
	}
}