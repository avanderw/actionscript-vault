package net.avdw.generated.wallpaper.assets.ivy
{
	import flash.display.Shape;
	import net.avdw.generated.wallpaper.drawStamp;
	
	public class WallpaperIvy022
	{
		[Embed(source="WallpaperIvy022.jpg")]
		static private const Img:Class;
		
		static public function create(width:int, height:int, round:int = 0):Shape {
			return drawStamp(width, height, new Img, round);
		}
	}
}