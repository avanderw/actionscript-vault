package net.avdw.math
{
	import net.avdw.random.randomNumber;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Range
	{
		public var lower:Number = Number.NEGATIVE_INFINITY;
		public var upper:Number = Number.POSITIVE_INFINITY;
		
		public var lowerBound:EBoundType;
		public var upperBound:EBoundType;
		
		public function Range(range:String = null)
		{
			if (range != null)
			{
				var v1:Number = Number(range.match(/([\d|\.]+)/)[0]);
				var v2:Number = Number(range.match(/([\d|\.]+)/g)[1]);
				var v1Bound:EBoundType = range.charAt(0) == "[" ? EBoundType.INCLUSIVE : EBoundType.EXCLUSIVE;
				var v2Bound:EBoundType = range.charAt(range.length - 1) == "]" ? EBoundType.INCLUSIVE : EBoundType.EXCLUSIVE;
				
				set(v1, v1Bound, v2, v2Bound);
			}
		}
		
		protected function set(v1:Number, v1Bound:EBoundType, v2:Number, v2Bound:EBoundType):Range
		{
			if (v1 < v2)
			{
				lower = v1;
				lowerBound = v1Bound;
				upper = v2;
				upperBound = v2Bound;
			}
			else
			{
				lower = v2;
				lowerBound = v2Bound;
				upper = v1;
				upperBound = v1Bound;
			}
			return this;
		}
		
		static public function open(v1:Number, v2:Number):Range
		{
			return new Range().set(v1, EBoundType.EXCLUSIVE, v2, EBoundType.EXCLUSIVE);
		}
		
		static public function closed(v1:Number, v2:Number):Range
		{
			return new Range().set(v1, EBoundType.INCLUSIVE, v2, EBoundType.INCLUSIVE);
		}
		
		static public function closedOpen(v1:Number, v2:Number):Range
		{
			return new Range().set(v1, EBoundType.INCLUSIVE, v2, EBoundType.EXCLUSIVE);
		}
		
		static public function openClosed(v1:Number, v2:Number):Range
		{
			return new Range().set(v1, EBoundType.EXCLUSIVE, v2, EBoundType.INCLUSIVE);
		}
		
		static public function greaterThan(v:Number):Range
		{
			return new Range().set(v, EBoundType.EXCLUSIVE, Number.POSITIVE_INFINITY, EBoundType.EXCLUSIVE);
		}
		
		static public function atLeast(v:Number):Range
		{
			return new Range().set(v, EBoundType.INCLUSIVE, Number.POSITIVE_INFINITY, EBoundType.EXCLUSIVE);
		}
		
		static public function lessThan(v:Number):Range
		{
			return new Range().set(v, EBoundType.EXCLUSIVE, Number.NEGATIVE_INFINITY, EBoundType.EXCLUSIVE);
		}
		
		static public function atMost(v:Number):Range
		{
			return new Range().set(v, EBoundType.INCLUSIVE, Number.NEGATIVE_INFINITY, EBoundType.EXCLUSIVE);
		}
		
		static public function all():Range
		{
			return new Range().set(Number.NEGATIVE_INFINITY, EBoundType.EXCLUSIVE, Number.POSITIVE_INFINITY, EBoundType.EXCLUSIVE);
		}
		
		public function selectUniform():Number
		{
			return randomNumber(lower, upper);
		}
		
		public function contains(... args):Boolean
		{
			var contained:Boolean = true;
			for (var i:int = 0; i < args.length && contained; i++)
			{
				contained = args[i] > lower;
				contained = args[i] < upper;
			}
			return contained;
		}
		
		public function encloses(that:Range):Boolean
		{
			if (this.equals(that))
				return true;
			
			var lowerEncloses:Boolean;
			switch (lowerBound)
			{
				case EBoundType.EXCLUSIVE: 
					lowerEncloses = this.lower < that.lower;
					break;
				case EBoundType.INCLUSIVE: 
					lowerEncloses = this.lower <= that.lower;
					break;
			}
			
			var upperEncloses:Boolean;
			switch (upperBound)
			{
				case EBoundType.EXCLUSIVE: 
					upperEncloses = this.upper > that.upper;
					break;
				case EBoundType.INCLUSIVE: 
					upperEncloses = this.upper >= that.upper;
					break;
			}
			return lowerEncloses && upperEncloses;
		}
		
		public function hasUpperBound():Boolean
		{
			return upper != Number.POSITIVE_INFINITY && !isNaN(upper);
		}
		
		public function hasLowerBound():Boolean
		{
			return lower != Number.NEGATIVE_INFINITY && !isNaN(lower);
		}
		
		public function isEmpty():Boolean
		{
			if (lower == upper && lowerBound == upperBound && lowerBound == EBoundType.EXCLUSIVE)
				throw new Error("Invalid range: " + this);
			
			return lower == upper && !(lowerBound == upperBound && lowerBound == EBoundType.INCLUSIVE);
		}
		
		public function isConnected(that:Range):Boolean
		{
			if (this.upper == that.lower && this.upperBound == that.lowerBound && this.upperBound == EBoundType.EXCLUSIVE) {
				return false;
			}
			
			if (that.upper == this.lower && that.upperBound == this.lowerBound && that.upperBound === EBoundType.EXCLUSIVE) {
				return false;
			}
			
			return this.upper >= that.lower && this.lower <= that.upper;
		}
		
		public function intersection(that:Range):Range
		{
			if (!this.isConnected(that))
				throw new Error("Ranges are not connected");
			
			var newLower:Number;
			var newLowerBound:EBoundType;
			if (this.lower < that.lower)
			{
				newLower = that.lower;
				newLowerBound = that.lowerBound;
			}
			else
			{
				newLower = this.lower;
				newLowerBound = that.lowerBound;
			}
			
			var newUpper:Number;
			var newUpperBound:EBoundType;
			if (this.upper > that.upper)
			{
				newUpper = that.upper;
				newUpperBound = that.upperBound;
			}
			else
			{
				newUpper = this.upper;
				newUpperBound = this.upperBound;
			}
			
			return new Range(newLowerBound.lowerSymbol + newLower + "," + newUpper + newUpperBound.upperSymbol);
		}
		
		public function span(that:Range):Range
		{
			var newLower:Number;
			var newLowerBound:EBoundType;
			if (this.lower > that.lower)
			{
				newLower = that.lower;
				newLowerBound = that.lowerBound;
			}
			else
			{
				newLower = this.lower;
				newLowerBound = this.lowerBound;
			}
			
			var newUpper:Number;
			var newUpperBound:EBoundType;
			if (this.upper < that.upper)
			{
				newUpper = that.upper;
				newUpperBound = that.upperBound;
			}
			else
			{
				newUpper = this.upper;
				newUpperBound = this.upperBound;
			}
			
			return new Range(newLowerBound.lowerSymbol + newLower + "," + newUpper + newUpperBound.upperSymbol);
		}
		
		public function equals(that:Range):Boolean
		{
			return this.lower == that.lower && this.lowerBound == that.lowerBound && this.upper == that.upper && this.upperBound == that.upperBound;
		}
		
		public function clone():Range
		{
			return new Range(lowerBound.lowerSymbol + lower + "," + upper + upperBound.upperSymbol);
		}
		
		public function toString():String
		{
			return lowerBound.lowerSymbol + lower + "," + upper + upperBound.upperSymbol;
		}
		
		public function get size():Number 
		{
			return Math.abs(upper - lower);
		}
	
	}
}

class EBoundType
{
	static public const INCLUSIVE:EBoundType = new EBoundType("INCLUSIVE", "[", "]");
	static public const EXCLUSIVE:EBoundType = new EBoundType("EXCLUSIVE", "(", ")");
	
	public var name:String;
	public var lowerSymbol:String;
	public var upperSymbol:String;
	
	public function EBoundType(name:String, lowerSymbol:String, upperSymbol:String)
	{
		this.upperSymbol = upperSymbol;
		this.lowerSymbol = lowerSymbol;
		this.name = name;
	}
}