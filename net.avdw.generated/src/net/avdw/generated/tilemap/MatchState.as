package net.avdw.entelekt.pacman
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class MatchState
	{
		public var index:int;
		public var data:Array;
		public var playerA:Player = new Player;
		public var playerB:Player = new Player;
		
		public function MatchState(index:String, state:Array)
		{
			this.index = int(index);
			this.data = state;
		}
	}

}

import flash.geom.Point;

class Player
{
	public var points:int;
	public var position:Point;
}