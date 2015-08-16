package net.avdw.animated.isowaves
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.geom.Point;
	import net.avdw.color.convertARGBtoHEX;
	import net.avdw.graphics.drawFastLine;
	import net.avdw.graphics.quad;
	import net.avdw.number.square;
	import net.hires.debug.Stats;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * http://www.openprocessing.org/sketch/5671
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(backgroundColor="0xFFFFFF",frameRate="30",width="680",height="495")]
	public class Main extends Sprite
	{
		private var halfw:int;
		private var halfh:int;
		private var a:Number = 0;
		private var c1:uint;
		private const c2:Number = convertARGBtoHEX(1, .3);
		private const c3:Number = convertARGBtoHEX(1, .6);
		private const iso1:Point = new Point;
		private const iso2:Point = new Point;
		private const iso3:Point = new Point;
		private const iso4:Point = new Point;
		private var shape:Shape;
		
		public var settings:Object = {period: 0.55, speed: 0.08, base: 40, size: 17, blockSize: 17};
		
		public function Main()
		{
			stage.quality = StageQuality.LOW;
			
			halfw = stage.stageWidth >> 1;
			halfh = stage.stageHeight >> 1;
			
			shape = new Shape();
			addChild(shape);
			
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addSlider("settings.period", 0, 1);
			gui.addSlider("settings.speed", 0, .5);
			gui.addSlider("settings.base", 24, 64);
			gui.addStepper("settings.size", 1, 32);
			gui.addStepper("settings.blockSize", 8, 24);
			gui.show();
			
			var stats:Stats = new Stats();
			addChild(stats);
			stats.x = stage.stageWidth - stats.width;
			
			
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(e:Event):void
		{
			shape.graphics.clear();
			var zt:Number, zm:Number, xt:Number, xm:Number;
			var y:int;
			var halfBlockSize:Number = settings.blockSize >> 1;
			
			a -= settings.speed;
			for (var x:int = -settings.size; x < settings.size; x++)
			{
				for (var z:int = -settings.size; z < settings.size; z++)
				{
					y = 24 * Math.cos(settings.period * distance(x, z) + a);
					
					xm = x * settings.blockSize - halfBlockSize;
					xt = x * settings.blockSize + halfBlockSize;
					zm = z * settings.blockSize - halfBlockSize;
					zt = z * settings.blockSize + halfBlockSize;
					
					iso1.x = xm - zm + halfw;
					iso1.y = (xm + zm) * .5 + halfh;
					iso2.x = xm - zt + halfw;
					iso2.y = (xm + zt) * .5 + halfh;
					iso3.x = xt - zt + halfw;
					iso3.y = (xt + zt) * .5 + halfh;
					iso4.x = xt - zm + halfw;
					iso4.y = (xt + zm) * .5 + halfh;
					
					c1 = convertARGBtoHEX(1, (210 + y) / 255);
					
					drawQuadOnShape(shape, iso2.x, iso2.y - y, iso3.x, iso3.y - y, iso3.x, iso3.y + settings.base, iso2.x, iso2.y + settings.base, 0, c2);
					drawQuadOnShape(shape, iso3.x, iso3.y - y, iso4.x, iso4.y - y, iso4.x, iso4.y + settings.base, iso3.x, iso3.y + settings.base, 0, c3);
					drawQuadOnShape(shape, iso1.x, iso1.y - y, iso2.x, iso2.y - y, iso3.x, iso3.y - y, iso4.x, iso4.y - y, 0, c1);
				}
			}
		}
		
		private function distance(x:Number, z:Number):Number
		{
			return Math.sqrt(x * x + z * z);
		}
		
		private function drawQuadOnShape(shape:Shape, x1:int, y1:int, x2:int, y2:int, x3:int, y3:int, x4:int, y4:int, color:uint, fill:uint):void
		{
			shape.graphics.lineStyle(1, color);
			shape.graphics.beginFill(fill);
			shape.graphics.moveTo(x1, y1);
			shape.graphics.lineTo(x2, y2);
			shape.graphics.lineTo(x3, y3);
			shape.graphics.lineTo(x4, y4);
			shape.graphics.endFill();
		}
	
	}

}