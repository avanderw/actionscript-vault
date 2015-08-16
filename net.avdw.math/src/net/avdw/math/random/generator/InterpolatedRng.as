package net.avdw.math.random.generator 
{
	import net.avdw.math.Range;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class InterpolatedRng 
	{
		
		public function InterpolatedRng(range:Range, samples:uint, interpolation:Function) 
		{
			throw new Error("Not implemented");
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