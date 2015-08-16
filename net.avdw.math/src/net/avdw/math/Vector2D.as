package net.avdw.math
{
	
	/**
	 * Mathematical vector class to make euclidian mathematics a bit easier.
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Vector2D
	{
		protected static const Epsilon:Number = 0.0000001;
		protected static const EpsilonSqr:Number = Epsilon * Epsilon;
		
		public var x:Number;
		public var y:Number;
		
		/**
		 * @param	... args (x, y) || (Vector2D) || (Point2D) || (Point)
		 */
		public function Vector2D(... args)
		{
			switch (args.length)
			{
				case 0: 
					x = 1;
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
		 * Sets the properties of the vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to the vector
		 */
		public function set(... args):Vector2D
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
			return this;
		}
		
		/**
		 * Adds a vector to this vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to the vector
		 */
		public function add(... args):Vector2D
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
			return this;
		}
		
		/**
		 * Subtracts a vector from this vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function subtract(... args):Vector2D
		{
			switch (args.length)
			{
				case 1: 
					x -= args[0].x;
					y -= args[0].y;
					break;
				case 2: 
					x -= args[0];
					y -= args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			return this;
		}
		
		/**
		 * Multiplies this vector by the parameter
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function multiply(... args):Vector2D
		{
			switch (args.length)
			{
				case 1: 
					x *= args[0].x;
					y *= args[0].y;
					break;
				case 2: 
					x *= args[0];
					y *= args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			return this;
		}
		
		/**
		 * Divides a vector into this vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function divide(... args):Vector2D
		{
			switch (args.length)
			{
				case 1: 
					x /= args[0].x;
					y /= args[0].y;
					break;
				case 2: 
					x /= args[0];
					y /= args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			return this;
		}
		
		/**
		 * Zeros this vector, same as calling set(0,0)
		 * @return	Reference to this vector
		 */
		public function zero():Vector2D
		{
			x = 0;
			y = 0;
			return this;
		}
		
		/**
		 * Multiplies this vector properties by a scalar value
		 * @param	value The amount to multiply each property by
		 * @return	Reference to this vector
		 */
		public function scale(value:Number):Vector2D
		{
			return multiply(value, value);
		}
		
		/**
		 * Makes the vector a unit vector (a.k.a. length = 1)
		 * @return Reference to this vector
		 */
		public function normalize():Vector2D
		{
			return length(1);
		}
		
		/**
		 * Gets or sets this vector length
		 * @param	value The length to set this vector to
		 * @return	Reference to this vector if setting, else the length when getting
		 */
		public function length(value:Number = Number.NaN):*
		{
			return isNaN(value) ? Math.sqrt(x * x + y * y) : scale(value / length());
		}
		
		/**
		 * The square of the length
		 * @return	Number representing the length squared of this vector
		 */
		public function lengthSqr():Number
		{
			return x * x + y * y;
		}
		
		/**
		 * The distance from this vector to another vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	The distance to the other vector
		 */
		public function distance(... args):Number
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
			return Math.sqrt(xd * xd + yd * yd);
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
		 * Checks whether a vector is equal to this vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Whether they are equal
		 */
		public function equals(... args):Boolean
		{
			var equal:Boolean = true;
			switch (args.length)
			{
				case 1: 
					equal = equal && x == args[0].x;
					equal = equal && y == args[0].y;
					break;
				case 2: 
					equal = equal && x == args[0];
					equal = equal && y == args[1];
					break;
				default: 
					throw new Error("unknown args");
			}
			return equal;
		}
		
		/**
		 * Checks whether this vector length is 1
		 * @return Whether this vector length is 1
		 */
		public function isNormalized():Boolean
		{
			return Math.abs(length() - 1) < Epsilon;
		}
		
		/**
		 * Checks whether this vector is zero
		 * @return Whether this vector is zero
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
		 * Checks whether whether this vector is closer than epsilon to the parameter
		 * @param	epsilon	Distance to be within
		 * @param	...args	(x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Whether the two vectors are closer than epsilon to each other
		 */
		public function isWithin(epsilon:Number, ... args):Boolean
		{
			return distanceSqr.apply(this, args) < epsilon * epsilon;
		}
		
		/**
		 * Checks to see if this vector is valid
		 * @return	Whether x && y are finite
		 */
		public function isValid():Boolean
		{
			return !isNaN(x) && !isNaN(y) && isFinite(x) && isFinite(y);
		}
		
		/**
		 * Whether this vector is a normal to another vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Whether they are normal to each other
		 */
		public function isNormalTo(... args):Boolean
		{
			return dot.apply(this, args) == 0;
		}
		
		/**
		 * Calculates the dot product between this vector and the parameter
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	The dot product between this vector and the parameter
		 */
		public function dot(... args):Number
		{
			switch (args.length)
			{
				case 1: 
					return x * args[0].x + y * args[0].y;
				case 2: 
					return x * args[0] + y * args[1];
				default: 
					throw new Error("unknown args");
			}
		}
		
		/**
		 * Calculates the cross product between two vectors
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	The cross product between two vectors
		 */
		public function cross(... args):Number
		{
			switch (args.length)
			{
				case 1: 
					return x * args[0].y - y * args[0].x;
				case 2: 
					return x * args[1] - y * args[0];
				default: 
					throw new Error("unknown args");
			}
		}
		
		/**
		 * Gets or sets the angle for this vector, with 0 being right
		 * @param	radians	The angel to set this vector to
		 * @return	The vector after setting the angle or the angle when getting
		 */
		public function angle(radians:Number = Number.NaN):*
		{
			if (isNaN(radians))
			{
				var ang:Number = Math.atan2(y, x);
				if (ang < 0)
					ang += MathConstant.TWO_PI;
					
				return ang;
			}
			else
			{
				const origLength:Number = length();
				x = origLength * Math.cos(radians);
				y = origLength * Math.sin(radians);
				return this;
			}
		}
		
		/**
		 * Calculates the angle between two vectors
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Angle between the two vectors
		 */
		public function angleBetween(... args):Number
		{
			switch (args.length)
			{
				case 1: 
					return args[0].angle() - angle();
				case 2: 
					return new Vector2D(args[0], args[1]).angle() - angle();
				default: 
					throw new Error("unknown args");
			}
		}
		
		/**
		 * Rotate this vector by the parameter
		 * @param	radians	The angle to rotate this vector by
		 * @return	Reference to this vector
		 */
		public function rotate(radians:Number):Vector2D
		{
			const s:Number = Math.sin(radians);
			const c:Number = Math.cos(radians);
			
			var newX:Number = x * c - y * s;
			var newY:Number = x * s + y * c;
			x = newX;
			y = newY;
			
			return this;
		}
		
		/**
		 * Creates a new vector for the right normal to this vector
		 */
		public function get normalRight():Vector2D
		{
			return new Vector2D(-y, x);
		}
		
		/**
		 * Creates a new vector for the left normal to this vector
		 */
		public function get normalLeft():Vector2D
		{
			return new Vector2D(y, -x);
		}
		
		/**
		 * Negate this vector (a.k.a. reverses the direction)
		 * @return	Reference to this vector
		 */
		public function negate():Vector2D
		{
			x = -x;
			y = -y;
			return this;
		}
		
		/**
		 * Linear interpolation between two vectors (e.g. straight line)
		 * @param	t		The percentage to interpolate
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return 	Reference to this vector
		 */
		public function lerp(t:Number, ... args):Vector2D
		{
			switch (args.length)
			{
				case 1: 
					x = x + t * (args[0].x - x);
					y = y + t * (args[0].y - y);
					break;
				case 2: 
					x = x + t * (args[0] - x);
					y = y + t * (args[1] - y);
					break;
				default: 
					throw new Error("unknown args");
			}
			return this;
		}
		
		/**
		 * Spherical interpolation between two vectors (e.g. circular)
		 * @param	t		Percentage to interpolate
		 * @param	...args	(x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function slerp(t:Number, ... args):Vector2D
		{
			const cosTheta:Number = dot.apply(this, args);
			const theta:Number = Math.acos(cosTheta);
			const sinTheta:Number = Math.sin(theta);
			const w1:Number = Math.sin((1 - t) * theta) / sinTheta;
			const w2:Number = Math.sin(t * theta) / sinTheta;
			
			const to:Vector2D = new Vector2D();
			to.set.apply(this, args);
			
			scale(w1).add(to.scale(w2));
			return this;
		}
		
		/**
		 * Faster less acurate version of spherical interpolation
		 * @param	t		Percentage to interpolate
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function nlerp(t:Number, ... args):Vector2D
		{
			args.unshift(t);
			lerp.apply(this, args);
			return normalize();
		}
		
		/**
		 * Reflect this vector over another vector
		 * @param	...args	(x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function reflect(... args):Vector2D
		{
			var d:Number;
			switch (args.length)
			{
				case 1: 
					d = 2 * (x * args[0].x + y * args[0].y);
					subtract(d * args[0].x, d * args[0].y);
					break;
				case 2: 
					d = 2 * (x * args[0] + y * args[1]);
					subtract(d * args[0], d * args[1]);
					break;
				default: 
					throw new Error("unknown args");
			}
			
			return this;
		}
		
		/**
		 * Project this vector onto another vector
		 * @param	...args (x, y) || (Vector2D) || (Point2D) || (Point)
		 * @return	Reference to this vector
		 */
		public function project(... args):Vector2D
		{
			var scalar:Number;
			var projVector:Vector2D;
			switch (args.length)
			{
				case 1: 
					projVector = args[0];
					scalar = dot(projVector) / projVector.lengthSqr();
					break;
				case 2: 
					projVector = new Vector2D(args[0], args[1]);
					scalar = dot(projVector) / projVector.lengthSqr();
					break;
				default: 
					throw new Error("unknown args");
			}
			
			set(projVector);
			scale(scalar);
			return this;
		}

		
		/**
		 * Offsets this point using polar notation
		 * @param	radius	distance to offset from center
		 * @param	angle	direction in which to offset
		 */
		public function offsetPolar(radius:Number, angle:Number):Vector2D 
		{
			x += radius * Math.cos(angle);
			y += radius * Math.sin(angle);
			return this;
		}
		
		/**
		 * Create a new vector of this vector
		 * @return New vector of this vector
		 */
		public function clone():Vector2D
		{
			return new Vector2D(this);
		}
		
		/**
		 * Create a new point of this vector
		 */
		public function get point():Point2D
		{
			return new Point2D(x, y);
		}
		
		/**
		 * Helper method to swap two vectors with each other
		 * @param	a	First vector
		 * @param	b	Second vector
		 */
		public static function swap(a:Vector2D, b:Vector2D):void
		{
			const tmp:Vector2D = a.clone();
			a.set(b);
			b.set(tmp);
		}
		
		/**
		 * Textual representation of this vector
		 * @return	String representation of this vector
		 */
		public function toString():String
		{
			return "[" + x + "," + y + "]";
		}
	}

}