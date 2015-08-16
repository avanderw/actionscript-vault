package net.avdw.debug
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import net.avdw.debug.isDebugBuild;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Debug
	{
		[Embed(source="../../../../../net.avdw.resource/image/icon/bug.png")]
		static private const BugBitmap:Class;
		static private var addedToStage:Boolean = false;
		
		static public function decorate(stage:Stage):void
		{
			if (isDebugBuild() && !addedToStage)
			{
				const img:Bitmap = new BugBitmap();
				img.width *= .3;
				img.height *=  .3;
				img.x = stage.stageWidth - img.width;
				stage.addChild(img);
				addedToStage = true;
				
				const stats:Stats = new Stats();
				stage.addChild(stats);
				stats.x = stage.stageWidth - stats.width;
				stats.y = stage.stageHeight - stats.height;
			}
		}
	}

}