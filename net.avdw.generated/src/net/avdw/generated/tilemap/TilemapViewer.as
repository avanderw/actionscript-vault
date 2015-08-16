package net.avdw.generated.tilemap
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import net.avdw.align.alignCenterTo;
	import net.avdw.pacman.entelect.Match;
	import net.avdw.pacman.entity.WallEntity;
	import net.avdw.pacman.WallTile;
	import net.avdw.pacman.WatchFile;
	import net.avdw.text.loadFile;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(width='800',height='800',frameRate='30',backgroundColor='#000000')]
	
	public class TilemapViewer extends Sprite
	{
		static private const wallTiles:Array = [];
		static private const file:File = File.applicationDirectory;
		
		public function TilemapViewer()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			[Embed(source="initial.state",mimeType="application/octet-stream")]
			const stateFile:Class;
			const state:Array = Match.loadIteration(loadFile(stateFile));
			const container:Sprite = new Sprite;
			
			addChild(container);
			
			const fileLastModifiedWatch:WatchFile = new WatchFile(file, refresh);
			stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					trace(e);
					fileLastModifiedWatch.timer.stop();
					file.browseForOpen("Tilemap");
				});
			file.addEventListener(Event.SELECT, function(e:Event):void
				{
					trace(e);
					const dim:Array = file.name.match(/(\d+)x(\d+)/);
					if (dim.length > 2)
					{
						WallTile.WIDTH = dim[1];
						WallTile.HEIGHT = dim[2];
						container.x = (stage.stageWidth - state[0].length * WallTile.WIDTH) / 2;
						container.y = (stage.stageHeight - state.length * WallTile.HEIGHT) / 2;
					}
					refresh();
					fileLastModifiedWatch.timer.start();
				});
			file.browseForOpen("Tilemap");
		}
		
		
	}
}

