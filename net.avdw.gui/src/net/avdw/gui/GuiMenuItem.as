package net.avdw.gui
{
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiMenuItem
	{
		public var name:String;
		public var data:*;
		public var children:Array = [];
		
		public function GuiMenuItem(name:String, data:* = null, children:Array = null)
		{
			if (children != null)
				this.children = children;
			
			this.data = data;
			this.name = name;
		}
	}
}