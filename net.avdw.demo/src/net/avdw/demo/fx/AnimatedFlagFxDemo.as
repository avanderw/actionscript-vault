package net.avdw.demo.fx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.avdw.align.alignCenterTo;
	import net.avdw.background.bgFromCode;
	import net.avdw.color.filterToGray;
	import net.avdw.demo.ADemo;
	import net.avdw.text.loadText;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class AnimatedFlagFxDemo extends ADemo
	{
		private var flag:Bitmap;
		private const seed:int = Math.random() * int.MAX_VALUE;
		private const offset:Array = [new Point(), new Point()];
		private var perlin:BitmapData;
		private var gradient:Shape;
		private var flagContainer:Sprite;
		private var lightBmpData:BitmapData;
		private var dropshadow:DropShadowFilter = new DropShadowFilter(4, 45, 0, .75, 16, 16);
		private var enhanceContrast:ColorTransform = new ColorTransform(2, 2, 2, 2, -60, -60, -60);
		
		public function AnimatedFlagFxDemo()
		{
			[Embed(source="AnimatedFlagFxDemo.as",mimeType="application/octet-stream")]
			const TextFile:Class;
			addChild(bgFromCode(stage.stageWidth, stage.stageHeight, TextFile));
			
			[Embed(source="../../../../../../net.avdw.assets/images/flag-south-africa-splatter.jpg")]
			const FlagClass:Class;
			
			flag = new FlagClass();
			flag.scaleX = flag.scaleY = .35;
			
			// effect setup
			perlin = new BitmapData(flag.width * 1.12, flag.height * 1.12);
			lightBmpData = new BitmapData(flag.width, flag.height);
			var light:Bitmap = new Bitmap(lightBmpData);
			light.blendMode = BlendMode.OVERLAY;
			
			
			// container allowing displacment outside of rect
			flagContainer = new Sprite();
			flagContainer.addChild(flag);
			flagContainer.addChild(light);
			alignCenterTo(stage, flagContainer);
			addChild(flagContainer);
			
			// gradient to reduce displacement
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(perlin.width, perlin.height);
			gradient = new Shape();
			gradient.graphics.beginGradientFill(GradientType.LINEAR, [0x008080, 0x008080], [1, 0], [0, 0x60], gradientMatrix);
			gradient.graphics.drawRect(0, 0, perlin.width, perlin.height);
			gradient.graphics.endFill();
			
			addEventListener(Event.ENTER_FRAME, animate);
		}
		
		private function animate(e:Event):void
		{
			offset[0].x -= .04 * perlin.width;
			offset[1].x -= .03 * perlin.width;
			perlin.perlinNoise(perlin.width, perlin.height, 2, seed, false, true, BitmapDataChannel.BLUE | BitmapDataChannel.GREEN, false, offset);
			perlin.draw(gradient);
			flagContainer.filters = [dropshadow, new DisplacementMapFilter(perlin, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.BLUE, .125 * flag.width, .2 * flag.height, DisplacementMapFilterMode.COLOR)];
			
			lightBmpData.draw(filterToGray(perlin.clone(), perlin), null, enhanceContrast);
		}
	}

}