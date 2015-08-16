package net.avdw.error
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DeprecatedError extends Error
	{
		public function DeprecatedError()
		{
			super("Method deprecated");
		}
	}
}