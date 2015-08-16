package net.avdw.game.component
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import net.avdw.animated.bars.AnimatedBars;
	import net.avdw.generated.image.GeneratedMosaic;
	import net.avdw.image.filters.AnimateBlur;
	import net.avdw.image.filters.FilterBlur;
	import net.avdw.image.filters.FilterGrayscale;
	import net.avdw.transition.ITransition;
	import net.avdw.transition.TransitionFade;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class MainPause extends Sprite
	{
		[Embed(source="../../../../../../assets/images/game-wallpaper-1.jpg")]
		private const DemoImage:Class;
		private const transition:ITransition = new TransitionFade();
		
		private var original:Bitmap;
		private var effect:Sprite;
		private var imageSwitch:Boolean = false;
		private var animate:AnimateBlur;
		
		
		public function MainPause()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			original = new DemoImage();
			effect = new Sprite();
			effect.addChild(new Bitmap(FilterGrayscale.create(FilterBlur.create(original))));
			effect.addChild(new AnimatedBars(new Rectangle(0, 0, 5, 20), new Rectangle(effect.width * .8, effect.height * .2, effect.width * .2 - 5, effect.height * .8 - 20)));
			effect.addChild(new AnimatedBars(new Rectangle(0, 0, 5, 20), new Rectangle(0, effect.height * .2, effect.width * .2 - 5, effect.height * .8 - 20)));
			effect.addChild(GeneratedMosaic.generateOverlay(effect.width, effect.height, 5, .85));
			
			addChild(effect);
			addChild(original);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (!imageSwitch)
				transition.transition(original, effect);
			else
				transition.transition(effect, original);
			
			imageSwitch = !imageSwitch;
		}
	}
}