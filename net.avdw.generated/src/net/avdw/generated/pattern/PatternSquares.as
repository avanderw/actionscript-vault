package net.avdw.generated.pattern
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class PatternSquares extends BitmapData
	{
		public function PatternSquares(width:uint = 5, height:uint = 5, color1:uint = 0x202020, color2:uint = 0x303030)
		{
			super(width, height, false, color2);
			
			const render:Shape = new Shape();
			render.graphics.lineStyle(1, color1);
			render.graphics.moveTo(width, 0);
			render.graphics.lineTo(0, 0);
			render.graphics.lineTo(0, height);
			
			draw(render);
		}
	}
}