package net.avdw.transition
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * Inspiration:
	 * http://www.joelambert.co.uk/flux/
	 *
	 * 				┌∩┐'(◣_◢)'┌∩┐
	 * @author Andrew van der Westhuizen
	 */
	public class TransitionVerticalBars extends ATransitionBars implements ITransition
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		
		private var numBars:int;
		private var direction:String;
		
		public function TransitionVerticalBars(numBars:int, direction:String = DOWN)
		{
			this.direction = direction;
			this.numBars = numBars;
		}
		
		/* INTERFACE net.avdw.transition.ITransition */
		public function transition(fromDisplayObject:DisplayObject, toDisplayObject:DisplayObject):void
		{
			// switch display objects visibility
			toDisplayObject.visible = true;
			fromDisplayObject.visible = false;
			
			// init resources
			const snapshot:Bitmap = new Bitmap(new BitmapData(fromDisplayObject.width, fromDisplayObject.height, true, 0));
			snapshot.bitmapData.draw(fromDisplayObject);
			
			const bars:Vector.<Bitmap> = createVerticalBars(snapshot);
			const masks:Vector.<Bitmap> = createMasks(bars);
			addResources(fromDisplayObject.parent, bars, masks);
			
			// animate resources
			for (var i:int = 0; i < numBars; i++)
			{
				const toY:int = direction == DOWN ? snapshot.height : -snapshot.height;
				
				if (i == numBars - 1)
					TweenLite.to(bars[i], .75, {y: toY, delay: i / numBars * .4, alpha: .6, onComplete: onCompleteTransition, onCompleteParams:[bars, masks, snapshot]});
				else
					TweenLite.to(bars[i], .75, {y: toY, delay: i / numBars * .4, alpha: .6});
			}
		}
		
		private function createVerticalBars(snapshot:Bitmap):Vector.<Bitmap>
		{
			const bars:Vector.<Bitmap> = new Vector.<Bitmap>();
			for (var i:int = 0; i < numBars; i++)
			{
				const bar:Bitmap = new Bitmap(new BitmapData(Math.ceil(snapshot.width/ numBars), snapshot.height, true, 0));
				bar.x = i * snapshot.width / numBars;
				bar.bitmapData.copyPixels(snapshot.bitmapData, bar.getRect(snapshot), new Point());
				bars.push(bar);
			}
			
			return bars;
		}
	}

}