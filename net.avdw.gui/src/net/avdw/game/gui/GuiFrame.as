package net.avdw.game.gui
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiFrame extends Shape
	{
		
		public function GuiFrame(width:int = 150, height:int = 50, color:uint = 0x808000, size:int = 1)
		{
			graphics.lineStyle(1, color);
			
			graphics.moveTo(1, 0);
			graphics.lineTo(width - 1, 0);
						
			graphics.moveTo(0, 1);
			graphics.lineTo(0, height - 1);
			
			graphics.moveTo(width-1, 1);
			graphics.lineTo(width-1, height - 1);
						
			graphics.moveTo(1, height);
			graphics.lineTo(width - 1, height);
			
			graphics.beginFill(color);
			graphics.drawRect(1, 1, width - 2, height - 2);
			graphics.endFill();
		}
	
	}

}