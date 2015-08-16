package net.avdw.error 
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class StaticClassError extends Error
	{
		
		public function StaticClassError(string:String = "Static class") 
		{
			super(string);
		}
		
	}

}