package net.avdw.gui
{
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.HexColorsPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiButton extends AGuiComponent
	{
		private static const padding:int = 3;
		private static const gradientBox:Matrix = new Matrix();
		private static const normalGradient:Object = {top: 0x9F9F9F, bottom: 0x5F5F5F};
		private static const hoverGradient:Object = {top: 0x20E8E8, bottom: 0x1D7081};
		private static const clickGradient:Object = {top: 0x1FE970, bottom: 0x1C8223};
		private static const bevelFilter:BevelFilter = new BevelFilter(1, 45, 0xFFFFFF, .5, 0, .5, 0, 0, 4);
		
		private const titleText:TextField = new TextField();
		private const currentGradient:Object = {top: 0x9F9F9F, bottom: 0x5F5F5F};
		
		private var callback:Function;
		private var payload:Object;
		
		public function GuiButton(label:String, callback:Function = null, payload:Object = null)
		{
			this.payload = payload;
			this.callback = callback;
			TweenPlugin.activate([HexColorsPlugin]);
			filters = [bevelFilter];
			
			titleText.defaultTextFormat = new TextFormat(null, 13, 0xFFFFFF);
			titleText.text = label;
			titleText.selectable = false;
			titleText.autoSize = TextFieldAutoSize.CENTER;
			addChild(titleText);
			
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function drawGradient():void
		{
			graphics.clear();
			const bgHeight:int = height + padding;
			const bgWidth:int = Math.max(parent != null ? parent.width : 0, width + 4 * padding);
			
			gradientBox.createGradientBox(bgWidth, bgHeight, Math.PI * .5);
			graphics.beginGradientFill(GradientType.LINEAR, [currentGradient.top, currentGradient.bottom], [1, 1], [0, 255], gradientBox);
			graphics.drawRect(0, 0, bgWidth, bgHeight);
			graphics.endFill();
		}
		
		override public function refresh():void
		{
			drawGradient();
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			addEventListener(MouseEvent.MOUSE_UP, this_mouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
		
		private function this_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			removeEventListener(MouseEvent.MOUSE_UP, this_mouseUp);
			removeEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, this_mouseDown);
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_mouseOver(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
			
			TweenLite.to(currentGradient, 1, {hexColors: hoverGradient, ease: Cubic.easeOut, onUpdate: drawGradient});
		}
		
		private function this_mouseOut(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			
			TweenLite.to(currentGradient, .5, {hexColors: normalGradient, ease: Cubic.easeIn, onUpdate: drawGradient});
		}
		
		private function this_mouseDown(e:MouseEvent):void
		{
			TweenLite.to(currentGradient, .2, {hexColors: clickGradient, ease: Cubic.easeOut, onUpdate: drawGradient});
		}
		
		private function this_mouseUp(e:MouseEvent):void
		{
			TweenLite.to(currentGradient, .25, {hexColors: hoverGradient, ease: Cubic.easeIn, onUpdate: drawGradient});
			if (callback != null)
				callback.apply(this, [payload]);
		}
	
	}

}