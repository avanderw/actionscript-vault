package net.avdw.debug
{
	import net.avdw.debug.isDebugBuild;
	
	public function tracepoint(... args):void
	{
		if (isDebugBuild())
		{
			var message:String = args.join(", ");
			var matches:Array = new Error().getStackTrace().split("\n")[2].match(/at\s(.*)\[.*:(\d+)/);
			trace("["+new Date().toLocaleTimeString() +"]", matches[2] + ":" + matches[1],((message != "") ? "[" + message + "]" : ""));
		}
	}

}