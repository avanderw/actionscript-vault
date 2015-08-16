package net.avdw.math.random.generator
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ConstantRng extends ARng
	{
		protected var base:Number;
		
		public function ConstantRng(base:Number)
		{
			this.base = base;
		}
		
		override public function random():Number
		{
			return base;
		}
		
		override public function reset():ARng
		{
			return this;
		}
	}

}