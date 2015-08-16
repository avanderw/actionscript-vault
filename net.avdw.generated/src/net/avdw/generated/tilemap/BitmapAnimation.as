package net.avdw.generated.tilemap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class BitmapAnimation extends Bitmap
	{
		static private const PLAYING:String = "Playing";
		static private const PLAYING_WITH_DELAY:String = "Playing with delay";
		static private const STOPPED:String = "Stopped";
		
		private var index:int;
		private var animationData:Vector.<BitmapData>;
		private const delayTimer:Timer = new Timer(100);
		private const playTimer:Timer = new Timer(100);
		private const states:StateMachine = new StateMachine();
		private var fps:int;
		private var repeatPlay:Boolean;
		private var repeatDelay:Boolean;
		private var delay:int;
		
		public function BitmapAnimation(animationData:Vector.<BitmapData>)
		{
			this.animationData = animationData;
			index = 0;
			bitmapData = animationData[index];
			
			playTimer.addEventListener(TimerEvent.TIMER, updateAnimation);
			playTimer.addEventListener(TimerEvent.TIMER_COMPLETE, playComplete);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayComplete);
			
			states.addState(PLAYING, {enter: startPlaying, from: [STOPPED]});
			states.addState(PLAYING_WITH_DELAY, {enter: startWithDelay, from: [STOPPED]});
			states.addState(STOPPED, {enter: stopPlaying, from: [PLAYING, PLAYING_WITH_DELAY]});
			states.initialState = STOPPED;
		}
		
		public function play(fps:int, repeat:Boolean = true):void
		{
			this.repeatPlay = repeat;
			this.fps = fps;
			states.changeState(PLAYING);
		}
		
		public function playAfterDelay(delay:int, fps:int, repeat:Boolean = true):void
		{
			this.repeatDelay = repeat;
			this.fps = fps;
			this.delay = delay;
			states.changeState(PLAYING_WITH_DELAY);
		}
		
		private function startWithDelay(e:StateMachineEvent):void
		{
			delayTimer.delay = delay;
			delayTimer.repeatCount = 1;
			delayTimer.start();
		}
		
		private function delayComplete(e:TimerEvent):void
		{
			repeatPlay = false;
			startPlaying();
		}
		
		private function startPlaying(e:StateMachineEvent = null):void
		{
			playTimer.delay = 1000 / fps;
			playTimer.repeatCount = repeatPlay ? 0 : animationData.length;
			playTimer.start();
		}
		
		private function playComplete(e:TimerEvent):void
		{
			switch (states.state)
			{
				case PLAYING_WITH_DELAY: 
					states.changeState(STOPPED);
					if (repeatDelay)
						states.changeState(PLAYING_WITH_DELAY);
					break;
				case PLAYING: 
					states.changeState(STOPPED);
					break;
			}
		}
		
		private function stopPlaying(e:StateMachineEvent):void
		{
			playTimer.stop();
			playTimer.reset();
			index = 0;
			bitmapData = animationData[index];
		}
		
		private function updateAnimation(e:TimerEvent):void
		{
			index = ++index % animationData.length;
			bitmapData = animationData[index];
		}
	}
}