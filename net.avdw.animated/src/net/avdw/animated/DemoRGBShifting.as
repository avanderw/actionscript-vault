package net.avdw.demo
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import net.avdw.align.alignCenterTo;
	import flash.display.BitmapData;
	import net.avdw.display.addChildrenTo;
	import net.avdw.fx.RGBDistortableFx;
	import net.avdw.generate.checkerboard;
	import net.hires.debug.Stats;
	import uk.co.soulwire.gui.SimpleGUI;
	import net.avdw.text.loadFile;
	//import net.avdw.generate.makeBackgroundFromText;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DemoRGBShifting extends Sprite
	{
		public var config:Object = {x: 10, y: 3, scaleX: .2, scaleY: .05, alpha: .5, speed: .8};
		
		[Embed(source="DemoRGBShifting.as",mimeType="application/octet-stream")]
		public const TextFile:Class;
		
		[Embed(source="../../../../../net.avdw.resource/image/character-monster.png")]
		private const ImageClass:Class;
		private var img:RGBDistortableFx;
		
		public function DemoRGBShifting()
		{
			//addChild(makeBackgroundFromText(loadFile(TextFile), stage.stageWidth, stage.stageHeight));
			
			img = new RGBDistortableFx(new ImageClass());
			alignCenterTo(stage, img);
			addChild(img);
			
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addSlider("config.x", 0, 20);
			gui.addSlider("config.y", 0, 20);
			gui.addSlider("config.scaleX", 0, 2);
			gui.addSlider("config.scaleY", 0, 2);
			gui.addSlider("config.alpha", 0, 1);
			gui.addSlider("config.speed", .1, 1);
			gui.addButton("start", {callback: distort});
			gui.addButton("stop", {callback: img.stop});
			gui.show();
			
			distort();
		}
		
		private function distort():void
		{
			img.distort(config);
		}
	
	}

}
