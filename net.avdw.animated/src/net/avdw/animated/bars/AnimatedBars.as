package net.avdw.animated.bars
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class AnimatedBars extends Sprite
	{
		private const bars:Vector.<Shape> = new Vector.<Shape>;
		
		private var baseColor:uint;
		private var baseDimensions:Rectangle;
		private var placeArea:Rectangle;
		
		public function AnimatedBars(baseDimensions:Rectangle, placeArea:Rectangle, baseColor:uint = 0x3F8FD2)
		{
			this.placeArea = placeArea;
			this.baseDimensions = baseDimensions;
			this.baseColor = baseColor;
			
			const numBars:int = 10;
			for (var i:int = 0; i < numBars; i++) {
				bars.push(createBar());
				placeBar(bars[i]);
				addChild(bars[i]);
			}
			
			addEventListener(Event.ENTER_FRAME, this_animate);
		}
		
		private function placeBar(bar:Shape):void 
		{
			bar.x = placeArea.x + placeArea.width * Math.random();
			bar.y = placeArea.y + placeArea.height * Math.random();
		}
		
		private function createBar():Shape
		{
			const matrix:Matrix = new Matrix();
			matrix.createGradientBox(baseDimensions.width, baseDimensions.height, Math.PI * .5)
			
			const shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.LINEAR, [baseColor, baseColor], [1, 0], [0, 255], matrix);
			shape.graphics.drawRect(0, 0, baseDimensions.width, baseDimensions.height);
			shape.graphics.endFill();
			return shape;
		}
		
		private function this_animate(e:Event):void 
		{
			for each (var bar:Shape in bars) {
				bar.y -= 2;
				if (bar.y < -baseDimensions.height) {
					placeBar(bar);
				}
			}
		}
	
	}

}