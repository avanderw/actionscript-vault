package net.avdw.generated.wallpaper.assets.damask
{
	import flash.display.Shape;
	import net.avdw.generated.wallpaper.drawStamp;
	
	public class WallpaperDamask182
	{
		[Embed(source="WallpaperDamask182.gif")]
		static private const Img:Class;
		
		static public function create(width:int, height:int, round:int = 0):Shape {
			return drawStamp(width, height, new Img, round);
		}
	}
}