package net.avdw.generated.cellauto 
{
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class EPosition 
	{
		static public const TOP_LEFT:EPosition = new EPosition("TOP_LEFT");
		static public const TOP:EPosition = new EPosition("TOP");
		static public const TOP_RIGHT:EPosition = new EPosition("TOP_RIGHT");
		static public const LEFT:EPosition = new EPosition("LEFT");
		static public const CENTER:EPosition = new EPosition("CENTER");
		static public const RIGHT:EPosition = new EPosition("RIGHT");
		static public const BOTTOM_LEFT:EPosition = new EPosition("BOTTOM_LEFT");
		static public const BOTTOM:EPosition = new EPosition("BOTTOM");
		static public const BOTTOM_RIGHT:EPosition = new EPosition("BOTTOM_RIGHT");
		
		private var type:String;
		
		public function EPosition(type:String)  
		{
			this.type = type;
		}
		
	}

}