package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import net.avdw.generate.*;
	import net.avdw.generate.pattern.*;
	
	public class Patterns extends Sprite
	{
		private const w:uint = 0xFFFFFFFF;
		private const b:uint = 0xFF000000;
		private const g:uint = 0xFF808080;
		
		private const grid7:Array = [
			[b, b, b, b, b, b, b],
			[b, w, b, w, b, w, b],
			[b, b, b, b, b, b, b],
			[b, w, b, w, b, w, b],
			[b, b, b, b, b, b, b],
			[b, w, b, w, b, w, b],
			[b, b, b, b, b, b, b]
			];
		private const raise7:Array = [
			[w, b, b, b, b, b, b],
			[w, g, g, g, g, g, b],
			[w, g, w, b, b, g, b],
			[w, g, w, g, b, g, b],
			[w, g, w, w, w, g, b],
			[w, g, g, g, g, g, b],
			[w, w, w, w, w, w, w]
			];
		
		public function Patterns()
		{			
			addChild(makeTextureFromPattern(stepPattern(), stage.stageWidth, stage.stageHeight));
		}
	}
}