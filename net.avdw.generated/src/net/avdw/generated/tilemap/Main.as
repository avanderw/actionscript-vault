package net.avdw.generated.tilemap
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.filesystem.File;
	import net.avdw.debug.tracepoint;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(width='800',height='700',frameRate='30',backgroundColor='#FFFFFF')]
	
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(new Match(File.applicationDirectory.resolvePath("demo-match")));
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onEnterExitFullScreen);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function onEnterExitFullScreen(e:FullScreenEvent):void
		{
			tracepoint();
			if (e.fullScreen)
			{
			}
			else
			{
			}
		}
		
		private function onResize(e:Event = null):void
		{
			tracepoint();
		}
	}

}