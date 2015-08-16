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
	public class TransitionHorizontalBars extends ATransitionBars implements ITransition
	{
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";
		
		private var numBars:int;
		private var direction:String;
		
		public function TransitionHorizontalBars(numBars:int, direction:String = RIGHT)
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
			
			const bars:Vector.<Bitmap> = createHorizontalBars(snapshot);
			const masks:Vector.<Bitmap> = createMasks(bars);
			addResources(fromDisplayObject.parent, bars, masks);
			
			// animate resources
			for (var i:int = 0; i < numBars; i++)
			{
				const toX:int = direction == RIGHT ? snapshot.width : -snapshot.width;
				
				if (i == numBars - 1)
					TweenLite.to(bars[i], .75, {x: toX, delay: i / numBars * .4, alpha: .6, onComplete: onCompleteTransition, onCompleteParams:[bars, masks, snapshot]});
				else
					TweenLite.to(bars[i], .75, {x: toX, delay: i / numBars * .4, alpha: .6});
			}
		}
		
		
		private function createHorizontalBars(snapshot:Bitmap):Vector.<Bitmap>
		{
			const bars:Vector.<Bitmap> = new Vector.<Bitmap>();
			for (var i:int = 0; i < numBars; i++)
			{
				const bar:Bitmap = new Bitmap(new BitmapData(snapshot.width, Math.ceil(snapshot.height / numBars), true, 0));
				bar.y = i * snapshot.height / numBars;
				bar.bitmapData.copyPixels(snapshot.bitmapData, bar.getRect(snapshot), new Point());
				bars.push(bar);
			}
			
			return bars;
		}
	}

}