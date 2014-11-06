package net.avdw.transition 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public interface ITransition 
	{
		function transition(fromImage:DisplayObject, toImage:DisplayObject):void;
	}

}