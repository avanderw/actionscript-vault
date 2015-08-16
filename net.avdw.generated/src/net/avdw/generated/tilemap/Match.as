package net.avdw.generated.tilemap
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Timer;
	import net.avdw.text.loadFile;
	import org.osflash.signals.Signal;
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Match extends Sprite
	{
		static private const PLAYING:String = "Playing";
		static private const PAUSED:String = "Paused";
		static private const STOPPED:String = "Stopped";
		
		public const states:Vector.<MatchState> = new Vector.<MatchState>;
		public const pacmanA:Pacman = new Pacman(true);
		public const pacmanB:Pacman = new Pacman(false);
		
		public var directory:File;
		public var winningPlayer:Pacman;
		public var outcomeReason:String;
		public var iterations:int;
		
		private const playSignal:Signal = new Signal();
		private const replayStateMachine:StateMachine = new StateMachine();
		
		private var currState:int = 0;
		
		public function Match(directory:File)
		{
			this.directory = directory;
			MatchLoader.load(this);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			pacmanA.whenDoneMoving.add(stepMatch);
			pacmanB.whenDoneMoving.add(stepMatch);
			
			replayStateMachine.addState(PLAYING, {enter:enterPlayingState, from:[STOPPED, PAUSED]});
			replayStateMachine.addState(PAUSED, {from:[PLAYING]});
			replayStateMachine.addState(STOPPED, {from:[PLAYING, PAUSED]});
			replayStateMachine.initialState = PLAYING;
		}
		
		public function get currentState():MatchState
		{
			return states[currState];
		}
		
		private function enterPlayingState(e:StateMachineEvent):void {
			stepMatch();
		}
		
		private function replayControl():void {
			//if (replayStateMachine.state == PLAYING)
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addChild(new Board(this));
		}
		
		private function stepMatch():void
		{
			if (!(pacmanA.loaded || pacmanB.loaded)) return;

			if (pacmanA.doneAnimating && pacmanB.doneAnimating && currState != iterations)
			{
				currState += 2;
				if (currState > iterations)
				{
					currState = iterations;
					replayStateMachine.changeState(STOPPED);
				}
				
				pacmanA.move(currentState.playerA.position);
				pacmanB.move(currentState.playerB.position);
			}
		}
	}
}

