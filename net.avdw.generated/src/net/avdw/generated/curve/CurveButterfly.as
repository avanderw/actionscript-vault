package net.avdw.generated.curve
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import net.avdw.math.Point2D;
	
	public class CurveButterfly extends Sprite
	{
		static public const PERIOD:Number = 24 * Math.PI;
		
		public function CurveButterfly(scale:Number = 48, color:uint = 0x999999)
		{
			var t:Number = 0;
			var lastPoint:Point2D = point(t, scale);
			
			graphics.lineStyle(1, color);
			graphics.moveTo(lastPoint.x, lastPoint.y);
			while ((t += .01) < PERIOD)
			{
				lastPoint = point(t, scale);
				graphics.lineTo(lastPoint.x, lastPoint.y);
			}
			graphics.lineTo(lastPoint.x, lastPoint.y);
		}
		
		static public function x(t:Number, scale:Number = 48):Number
		{
			return -Math.sin(t) * (Math.pow(Math.E, Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)) * scale;
		}
		
		static public function y(t:Number, scale:Number = 48):Number
		{
			return -Math.cos(t) * (Math.pow(Math.E, Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)) * scale;
		}
		
		static public function point(t:Number, scale:Number = 48):Point2D
		{
			var tmp:Number = (Math.pow(Math.E, Math.cos(t)) - 2 * Math.cos(4 * t) - Math.pow(Math.sin(t / 12), 5)) * scale;
			return new Point2D(-Math.sin(t) * tmp, -Math.cos(t) * tmp);
		}
		
		static public function r(theta:Number, scale:Number = 48):Number
		{
			return -Math.pow(Math.E, Math.cos(theta)) - 2 * Math.cos(4 * theta) + Math.pow(Math.sin((2 * theta - Math.PI) / 24), 5) * scale;
		}
	}
}