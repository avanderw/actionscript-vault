package net.avdw.generated.image.filters
{
	import flash.display.Bitmap;
	import net.avdw.transition.ITransition;
	import net.avdw.transition.TransitionFade;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class AnimateGrayscale
	{
		private var transition:ITransition = new TransitionFade();
		private var original:Bitmap;
		private var grayscale:Bitmap;
		
		public function AnimateGrayscale(original:Bitmap)
		{
			this.original = original;
			
			grayscale = new Bitmap(FilterGrayscale.create(original));
			grayscale.visible = false;
			original.parent.addChild(grayscale);
		}
		
		public function revert():void
		{
			transition.transition(grayscale, original);
		}
		
		public function animate():void
		{
			transition.transition(original, grayscale);
		}
	
	}

}