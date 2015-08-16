package net.avdw.generated.tilemap 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import net.avdw.debug.tracepoint;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class BitmapLoader 
	{
		public function BitmapLoader(file:File, callback:Function) 
		{
			const loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				const bitmap:Bitmap = new Bitmap(new BitmapData(loader.width, loader.height, true, 0));
				bitmap.bitmapData.draw(loader);
				callback.call(null, bitmap);
			});
			tracepoint(file.url);
			loader.load(new URLRequest(file.url));
		}
	}

}