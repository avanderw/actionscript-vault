package net.avdw.math
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Point2D
	{
		protected static const Epsilon:Number = 0.0000001;
		protected static const EpsilonSqr:Number = Epsilon * Epsilon;
		
		public var x:Number;
		public var y:Number;
		
		public var onUpdate:Function;
		
		/**
		 * @param	... args (x, y) || (Vector2D) || (Point2D) || (Point)
		 */
		public function Point2D(... args)
		{
			switch (args.length)
			{
				case 0: 
					x = 0;
					y = 0;
					break;
				case 1: 
					x = args[0].x;
					y = args[0].y;
					break;
				case 2: 
					x = args[0];
					y = args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
		}
		
		/**
		 * Sets the properties of the point
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this point
		 */
		public function set(... args):Point2D
		{
			switch (args.length)
			{
				case 1: 
					x = args[0].x;
					y = args[0].y;
					break;
				case 2: 
					x = args[0];
					y = args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			onUpdate();
			return this;
		}
		
		/**
		 * Adds a vector to this vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this point
		 */
		public function add(... args):Point2D
		{
			switch (args.length)
			{
				case 1: 
					x += args[0].x;
					y += args[0].y;
					break;
				case 2: 
					x += args[0];
					y += args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			onUpdate();
			return this;
		}
		
		/**
		 * Checks whether this point is zero
		 * @return Whether this point is zero
		 */
		public function isZero():Boolean
		{
			return x == 0 && y == 0;
		}
		
		/**
		 * Checks whether this vectors is very close to the parameter
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Whether they closer than Epsilon to each other
		 */
		public function isNear(... args):Boolean
		{
			return distanceSqr.apply(this, args) < EpsilonSqr;
		}
		
		/**
		 * The distance squared to another vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	The distance to the other vector squared
		 */
		public function distanceSqr(... args):Number
		{
			var xd:Number, yd:Number;
			switch (args.length)
			{
				case 1: 
					xd = x - args[0].x;
					yd = y - args[0].y;
					break;
				case 2: 
					xd = x - args[0];
					yd = y - args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			return xd * xd + yd * yd;
		}
		
		/**
		 * Clones this point
		 * @return	A reference to the cloned point
		 */
		public function clone():Point2D 
		{
			return new Point2D(this);
		}
		
		/**
		 * Offsets this point using polar notation
		 * @param	radius	distance to offset from center
		 * @param	angle	direction in which to offset
		 */
		public function offsetPolar(radius:Number, angle:Number):Point2D 
		{
			x += radius * Math.cos(angle);
			y += radius * Math.sin(angle);
			return this;
		}
		
	}
}