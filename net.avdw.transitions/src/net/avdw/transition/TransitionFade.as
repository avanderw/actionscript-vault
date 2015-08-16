package net.avdw.transition
{
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TransitionFade implements ITransition
	{
		public var isActive:Boolean = false;
		
		public function TransitionFade()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		/* INTERFACE net.avdw.transition.Transition */
		public function transition(fromImage:DisplayObject, toImage:DisplayObject):void
		{
			if (isActive)
				return;
				
			var parent:DisplayObjectContainer = fromImage.parent;
			if (parent == null)
				parent = toImage.parent;
				
			if (parent == null) {
				trace(this + ": no parent");
				return;
			}
				
			parent.addChild(toImage);
			parent.addChild(fromImage);
			toImage.alpha = 1;
			toImage.visible = true;
			
			isActive = true;
			TweenLite.to(fromImage, 1, {autoAlpha: 0, onComplete: function():void
				{
					isActive = false;
					parent.removeChild(fromImage);
				}});
		
		}
	
	}

}