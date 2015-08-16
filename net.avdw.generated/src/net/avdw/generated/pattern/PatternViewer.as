package net.avdw.generated.pattern
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.align.alignHorizontalCenterTo;
	import net.avdw.align.spaceHorizontal;
	import net.avdw.align.spaceVertical;
	import net.avdw.border.BorderRagePixel;
	import net.avdw.gui.SelectionBar;
	import net.avdw.layer.layerFromHueRange;
	import net.avdw.math.Range;
	
	[SWF(width='543',height='512',frameRate='30',backgroundColor='#FFFFFF')]
	
	public class PatternViewer extends Sprite
	{
		static private const CENTER_SQUARE:Object = {name: "Center square pattern", func: centerSquarePattern};
		static private const CHECKERBOARD:Object = {name: "Checkerboard pattern", func: checkerboardPattern};
		static private const CHECKERBOARD_TILE:Object = {name: "Checkerboard tile pattern", func: checkerboardTile};
		static private const DIAGONAL:Object = {name: "Diagonal pattern", func: diagonalPattern};
		static private const MOSAIC:Object = {name: "Mosaic pattern", func: mosaicPattern};
		static private const SCANLINE:Object = {name: "Scanline pattern", func: scanlinePattern};
		static private const STEP:Object = { name: "Step pattern", func: stepPattern };
		static private const SQUARES:Object = { name:"Squares", pattern:PatternSquares };
		
		private const selectionBar:SelectionBar = new SelectionBar();
		private const pattern:Bitmap = new Bitmap;
		private const squareTexture:Shape = new Shape;
		private const rectangleTexture:Sprite = new Sprite;
		private const textureWidth:int = 256;
		private const textureHeight:int = 256;
		private const patternWidth:int = 64;
		private const patternHeight:int = 64;
		
		public function PatternViewer()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			selectionBar.add(CENTER_SQUARE, CHECKERBOARD, CHECKERBOARD_TILE, DIAGONAL, MOSAIC, SCANLINE, STEP, SQUARES);
			selectionBar.onChange.add(update);
			
			pattern.x = 5;
			pattern.y = 20;
			squareTexture.y = pattern.y;
			squareTexture.x = pattern.x + patternWidth + 5;
			rectangleTexture.x = pattern.x;
			rectangleTexture.y = squareTexture.y + textureHeight + 5;
			addChild(squareTexture);
			addChild(rectangleTexture);
			addChild(pattern);
			addChild(selectionBar);
			
			const overlayLayer:Bitmap = new Bitmap(layerFromHueRange(stage.stageWidth, stage.stageHeight, Range.closed(0, 180)));
			overlayLayer.blendMode = BlendMode.OVERLAY;
			addChild(overlayLayer);
			
			update(SQUARES);
		}
		
		private function update(type:Object):void
		{
			if (pattern.bitmapData)
				pattern.bitmapData.dispose();
			
			if (type.hasOwnProperty("func"))				
				pattern.bitmapData = type.func.call();
			else
				pattern.bitmapData = new type.pattern();
			
			with (squareTexture.graphics)
			{
				clear();
				beginBitmapFill(pattern.bitmapData);
				drawRect(0, 0, textureWidth, textureHeight);
				endFill();
			}
			
			with (rectangleTexture.graphics)
			{
				clear();
				beginFill(0x7F7F7F);
				drawRect(0, 0, textureWidth + patternWidth +5, patternHeight);
				endFill();
				beginBitmapFill(pattern.bitmapData);
				drawRect(0, 0, textureWidth + patternWidth +5, patternHeight);
				endFill();
			}
			
			pattern.width = patternWidth;
			pattern.height = patternHeight;
			alignHorizontalCenterTo(stage, selectionBar);
		}
	
	}

}