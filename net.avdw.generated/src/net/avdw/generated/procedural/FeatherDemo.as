package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.avdw.generate.drawFeather;
	import uk.co.soulwire.gui.SimpleGUI;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(backgroundColor=0x0)]
	
	public class FeatherDemo extends Sprite
	{
		public var featherType:Number = 0;
		
		public function FeatherDemo()
		{
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addSlider("featherType", 0, .5, {callback: draw});
			gui.addButton("generate", {callback: draw});
			gui.show();
			
			draw();
		}
		
		private function draw():void
		{
			drawFeather(graphics, new Point(stage.stageWidth * .5, stage.stageHeight * .9), new Point(stage.stageWidth * .5, stage.stageHeight * .3), featherType, 0xFFFFFF, 100);
		}
	
	}

}