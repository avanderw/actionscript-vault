package net.avdw.generated.wallpaper.assets.mottled
{
	import flash.display.Shape;
	import net.avdw.generated.wallpaper.drawStamp;
	
	public class WallpaperMottled144
	{
		[Embed(source="WallpaperMottled144.jpg")]
		static private const Img:Class;
		
		static public function create(width:int, height:int, round:int = 0):Shape {
			return drawStamp(width, height, new Img, round);
		}
	}
}