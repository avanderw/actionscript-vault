package net.avdw.entelekt.pacman
{
	import flash.filesystem.File;
	import flash.geom.Point;
	import net.avdw.debug.tracepoint;
	import net.avdw.text.loadFile;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class MatchLoader
	{
		static public function load(match:Match):void
		{
			if (match.directory == null || !match.directory.exists || !match.directory.isDirectory)
				throw new Error();
			
			const log:File = match.directory.resolvePath("match.log");
			const replay:File = match.directory.resolvePath("replay");
			const info:File = match.directory.resolvePath("replay/matchinfo.out");
			
			loadReplay(replay, match);
			loadInfo(info, match);
			loadLog(log, match);
			
			match.pacmanA.place(match.currentState.playerA.position);
			match.pacmanB.place(match.currentState.playerB.position);
		}
		
		static private function loadInfo(info:File, match:Match):void
		{
			tracepoint();
			const contents:String = loadFile(info);
			
			for each (var line:String in contents.split("\r\n"))
			{
				if (line.indexOf(":") != -1)
				{
					const splitLine:Array = line.split(":");
					const details:Array = splitLine[1].split(",");
					switch (splitLine[0])
					{
						case "PLAYER": 
							switch (details[0])
						{
							case "A": 
								match.pacmanA.botName = details[1];
								match.pacmanA.endScore = details[2];
								break;
							case "B": 
								match.pacmanB.botName = details[1];
								match.pacmanB.endScore = details[2];
								break;
							default: 
								throw new Error(info + " player id != A or B [id=" + details[0] + "]");
						}
							break;
						case "GAME": 
							match.winningPlayer = details[0] == 'A' ? match.pacmanA : match.pacmanB;
							match.outcomeReason = details[1];
							match.iterations = details[2];
							break;
						default: 
							throw new Error(info + " unknown entry [start=" + splitLine[0] + "]");
					}
				}
			}
		}
		
		static private function loadReplay(replay:File, match:Match):void
		{
			const replayFiles:Array = replay.getDirectoryListing();
			for each (var replayFile:File in replayFiles)
			{
				if (replayFile.extension == "state")
				{
					const contents:String = loadFile(replayFile);
					const state:Object = loadState(contents);
					const index:String = replayFile.name.match(/\d+/)[0];
					const matchState:MatchState = new MatchState(index, state.data);
					matchState.playerA.position = state.playerAPosition;
					matchState.playerB.position = state.playerBPosition;
					match.states.push(matchState);
				}
			}
			match.states.sort(function(left:MatchState, right:MatchState):Number
				{
					return left.index - right.index;
				});
		}
		
		static private function loadState(fileContents:String):Object
		{
			const data:Array = [];
			const rowStrings:Array = fileContents.split("\n");
			for each (var rowString:String in rowStrings)
			{
				var rowArray:Array = [];
				for (var col:int = 0; col < rowString.length; col++)
				{
					switch (rowString.charAt(col))
					{
						case "A": 
							const playerAPosition:Point = new Point(col, data.length);
							break;
						case "B": 
							const playerBPosition:Point = new Point(col, data.length);
							break;
					}
					rowArray.push(rowString.charAt(col));
				}
				data.push(rowArray);
			}
			
			return {data: data, playerAPosition: playerAPosition, playerBPosition: playerBPosition};
		}
		
		static private function loadLog(file:File, match:Match):void
		{
			const contents:String = loadFile(file);
			var round:int = 0;
			var coord:Array;
			for each (var line:String in contents.split("\r\n"))
			{
				switch (line)
				{
					case "[GAME] : ProceedToNextRound": 
						round++;
						break;
					default: 
						if (line.indexOf("[GAME] : Player " + match.pacmanA.botName) != -1)
							match.states[round].playerA.points = line.match(/has (\d+) points/)[1];
						else if (line.indexOf("[GAME] : Player " + match.pacmanB.botName) != -1)
							match.states[round].playerB.points = line.match(/has (\d+) points/)[1];
				}
			}
		}
	
	}

}