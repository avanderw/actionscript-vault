package net.avdw.math.pip
{
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import net.avdw.debug.SWFProfiler;
	import net.avdw.font.FontConsolas;
	import net.avdw.geom.pointInPoly;
	import net.avdw.text.embeddedFont;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(backgroundColor="0xFFFFFF",frameRate="30",width="680",height="495")]
	public class Main extends Sprite 
	{
		private const hint:TextField = FontConsolas.createTextfied("Click to start drawing points...", 14);
		private const data:Vector.<Number> = new Vector.<Number>();
		private const poly:Vector.<Point> = new Vector.<Point>();
		private const commands:Vector.<int> = new Vector.<int>;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(hint);
			
			stage.addEventListener(MouseEvent.CLICK, stage_mouseClick);
			addEventListener(Event.ENTER_FRAME, this_enterFrame);
		}
		
		private function stage_mouseClick(e:MouseEvent):void 
		{
			commands.push((commands.length == 0) ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
			data.push(mouseX, mouseY);
			poly.push(new Point(mouseX, mouseY));
		}
		
		private function this_enterFrame(e:Event):void 
		{
			const isPointInPoly:Boolean = pointInPoly(poly, mouseX, mouseY);
			graphics.clear();
			graphics.lineStyle(1);
			graphics.beginFill(isPointInPoly ? 0x00FF00 : 0xFF0000);
			graphics.drawPath(commands, data);
			graphics.endFill();
			
			if (commands.length > 2) {
				hint.text = "Is the mouse point in the polygon? ";
				hint.appendText(isPointInPoly ? "yes" : "no");
			}
		}
		
	}
	
}