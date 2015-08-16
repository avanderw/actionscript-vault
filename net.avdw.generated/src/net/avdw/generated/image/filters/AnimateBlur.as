package net.avdw.generated.image.filters
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import net.avdw.transition.ITransition;
	import net.avdw.transition.TransitionFade;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class AnimateBlur
	{
		private var transition:ITransition = new TransitionFade();
		private var original:Bitmap;
		
		public function AnimateBlur(original:Bitmap)
		{
			this.original = original;
			
			TweenPlugin.activate([BlurFilterPlugin]); 
		}
		
		public function revert():void
		{
			TweenLite.to(original, 1, {blurFilter: {blurX: 1, blurY: 1, remove: true}});
		}
		
		public function animate():void
		{
			TweenLite.to(original, 1, {blurFilter: {blurX: 10, blurY: 10}});
		}
	
	}

}