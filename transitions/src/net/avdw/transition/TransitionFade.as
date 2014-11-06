package net.avdw.transition
{
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TransitionFade implements ITransition
	{
		
		public function TransitionFade()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		/* INTERFACE net.avdw.transition.Transition */
		
		public function transition(fromImage:DisplayObject, toImage:DisplayObject):void
		{
			toImage.alpha = 0;
			toImage.visible = true;
			TweenLite.to(toImage, 1, {alpha: 1});
			TweenLite.to(fromImage, 1, {autoAlpha: 0});
		}
	
	}

}