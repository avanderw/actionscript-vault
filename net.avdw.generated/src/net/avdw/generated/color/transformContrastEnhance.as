package net.avdw.color
{
	import flash.geom.ColorTransform;
	
	public function transformContrastEnhance():ColorTransform
	{
		return new ColorTransform(1.5, 1.5, 1.5, 1, -40, -40, -40);
	}

}