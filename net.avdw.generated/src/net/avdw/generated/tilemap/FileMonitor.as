package net.avdw.entelekt.pacman 
{
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class FileMonitor 
	{
		public const monitor:Timer = new Timer(250);
		
		private var file:File;
		private var callback:Function;
		private var lastModified:Number;
		
		/**
		 * First file check will always fire the callback.
		 * 
		 * @param	file		the file to monitor
		 * @param	callback	will be called with the file reference as an argument
		 */
		public function FileMonitor(file:File, callback:Function) 
		{
			this.callback = callback;
			this.file = file;
			lastModified = new Date(2000, 0, 0).time;
			
			monitor.addEventListener(TimerEvent.TIMER, checkForUpdate);
			monitor.start();
		}
		
		private function checkForUpdate(e:TimerEvent):void 
		{
			if (file.exists && file.modificationDate.time != lastModified) {
				lastModified = file.modificationDate.time;
				callback.call(null, file);
			}
		}
		
	}

}