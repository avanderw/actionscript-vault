package net.avdw.game 
{
	import flash.display.Sprite;
	import net.avdw.game.gui.GuiFrame;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class MainFrame extends Sprite
	{
		
		public function MainFrame() 
		{
			const frame:GuiFrame = new GuiFrame();
			frame.x = frame.y = 150;
			
			addChild(frame);
		}
		
	}

}