package net.avdw.generated.wallpaper.assets.ivy
{
	import flash.display.Shape;
	import net.avdw.generated.wallpaper.drawStamp;
	
	public class WallpaperIvy050
	{
		[Embed(source="WallpaperIvy050.gif")]
		static private const Img:Class;
		
		static public function create(width:int, height:int, round:int = 0):Shape {
			return drawStamp(width, height, new Img, round);
		}
	}
}