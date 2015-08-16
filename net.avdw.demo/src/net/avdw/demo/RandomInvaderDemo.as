package net.avdw.demo
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import net.avdw.color.convertHEXtoHUE;
	import net.avdw.file.loadTextFile;
	import net.avdw.fx.AnimatedNoiseFx;
	import net.avdw.fx.RefreshBarFx;
	import net.avdw.generate.makeBackgroundFromText;
	import net.avdw.generate.makeInvader;
	import net.avdw.number.ConstantNG;
	import net.avdw.number.isEven;
	import net.avdw.number.SeededOffsetRNG;
	import net.avdw.number.SeededRNG;
	import net.avdw.palette.HSLColorPalette;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RandomInvaderDemo extends Sprite
	{
		public var fillRatio:Number = .5;
		public var lightToDarkRatio:Number = .5;
		public var lightColor:uint = 0xFF0ACF00;
		public var darkColor:uint = 0xFF0ACF00;
		
		private var bmp:Bitmap;
		private var invaders:Array;
		private var lightColorPicker:HSLColorPalette;
		private var darkColorPicker:HSLColorPalette;
		private var rows:int;
		private var cols:int;
		private var gui:SimpleGUI;
		private var guiVisible:Boolean = true;
		
		public var invaderWidth:int = 7;
		public var invaderHeight:int = 9;
		public var scale:int = 5;
		public var gap:int = 11;
		
		public function RandomInvaderDemo()
		{
			lightColorPicker = new HSLColorPalette(new SeededOffsetRNG(convertHEXtoHUE(lightColor), 25), new SeededOffsetRNG(.5, .2), new ConstantNG(.5));
			darkColorPicker = new HSLColorPalette(new SeededOffsetRNG(convertHEXtoHUE(darkColor), 25), new SeededOffsetRNG(.8, .2), new ConstantNG(.3));
			
			gui = new SimpleGUI(this);
			gui.addGroup("runtime controls");
			gui.addSlider("fillRatio", 0, 1);
			gui.addColour("lightColor", {callback: colorChange});
			gui.addColour("darkColor", {callback: colorChange});
			gui.addSlider("lightToDarkRatio", 0, 1);
			gui.addGroup("resetting controls");
			gui.addStepper("invaderWidth", 3, 99, {callback: reset});
			gui.addStepper("invaderHeight", 3, 99, {callback: reset});
			gui.addStepper("scale", 1, 100, {callback: reset});
			gui.addStepper("gap", 0, 100, {callback: reset});
			gui.addButton("reset", {callback: reset});
			gui.addGroup("");
			gui.addLabel("press space to toggle the menu");
			gui.show();
			
			var timer:Timer = new Timer(0, 0);
			timer.addEventListener(TimerEvent.TIMER, generate);
			timer.start();
			
			reset();
			for (var i:int = 0; i < 2; i++)
				animateScale();
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyPressed);
		}
		
		private function keyPressed(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
				guiVisible = !guiVisible;
			
			if (!guiVisible)
				gui.hide();
		}
		
		private function animateScale():void
		{
			var x:int, y:int;
			var invader:Bitmap = invaders[int(Math.random() * invaders.length)][int(Math.random() * invaders[0].length)];
			addChild(invader);
			if (guiVisible)
				gui.show();
			TweenLite.to(invader, .15, {scaleX: 2 * scale, scaleY: 2 * scale, x: invader.x - scale * invaderWidth / 2, y: invader.y - scale * invaderHeight / 2, onComplete: function():void
				{
					TweenLite.to(invader, .15, {scaleX: scale, scaleY: scale, x: invader.x + scale * invaderWidth / 2, y: invader.y + scale * invaderHeight / 2, onComplete: animateScale});
				}});
		}
		
		private function colorChange():void
		{
			lightColorPicker.hueNG.baseNumber = convertHEXtoHUE(lightColor);
			darkColorPicker.hueNG.baseNumber = convertHEXtoHUE(darkColor);
		}
		
		private function generate(e:TimerEvent):void
		{
			makeInvader(invaders[0][0].width, invaders[0][0].height, fillRatio, lightToDarkRatio, lightColorPicker.generateColor(), darkColorPicker.generateColor(), invaders[int(Math.random() * invaders.length)][int(Math.random() * invaders[0].length)].bitmapData);
		}
		
		private function reset():void
		{
			if (isEven(invaderWidth))
				invaderWidth++;
			
			var y:int, x:int;
			rows = Math.ceil(stage.stageHeight / (invaderHeight * scale + gap));
			cols = Math.ceil(stage.stageWidth / (invaderWidth * scale + gap));
			
			if (invaders != null)
				for (y = 0; y < invaders.length; y++)
					for (x = 0; x < invaders[0].length; x++)
						invaders[y][x].bitmapData.dispose();
			
			invaders = [];
			var invader:Bitmap;
			for (y = 0; y < rows; y++)
			{
				var invaderRow:Array = [];
				for (x = 0; x < cols; x++)
				{
					invader = new Bitmap(makeInvader(invaderWidth, invaderHeight, fillRatio, lightToDarkRatio, lightColorPicker.generateColor(), darkColorPicker.generateColor()));
					invader.x = x * (invaderWidth * scale + gap);
					invader.y = y * (invaderHeight * scale + gap);
					invader.scaleX = invader.scaleY = scale;
					invaderRow.push(invader);
					addChild(invader);
				}
				invaders.push(invaderRow);
			}
			
			graphics.beginFill(0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x333333);
			for (x = 1; x < cols; x++)
			{
				graphics.moveTo(x * (invaderWidth * scale + gap) - Math.ceil(gap / 2), 0);
				graphics.lineTo(x * (invaderWidth * scale + gap) - Math.ceil(gap / 2), stage.stageHeight);
			}
			
			for (y = 1; y < rows; y++)
			{
				graphics.moveTo(0, y * (invaderHeight * scale + gap) - Math.ceil(gap / 2));
				graphics.lineTo(stage.stageWidth, y * (invaderHeight * scale + gap) - Math.ceil(gap / 2));
			}
		}
	}
}
