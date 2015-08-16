package net.avdw.math
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import net.avdw.decoration.wallpaper.WallpaperMottled040;
	import net.avdw.graphics.drawArc;
	import net.avdw.math.MathConstant;
	import net.avdw.math.Point2D;
	import net.avdw.math.Vector2D;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DemoArcDrawing extends Sprite
	{
		private const arcStartText:TextField = new TextField();
		private const arcEndText:TextField = new TextField();
		private const arcShape:Shape = new Shape;
		private const arcEndControl:Sprite = new Sprite;
		private const arcStartControl:Sprite = new Sprite;
		
		private var angleStart:Number = 0;
		private var angleEnd:Number = Math.PI / 4;
		
		public function DemoArcDrawing()
		{
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			addChild(WallpaperMottled040.create(stage.stageWidth, stage.stageHeight));
			
			const vectorLength:int = 150;
			var arcStartPoint:Point2D = new Point2D().offsetPolar(vectorLength, angleStart);
			var arcEndPoint:Point2D = new Point2D().offsetPolar(vectorLength, angleEnd);
			
			arcShape.x = stage.stageWidth >> 1;
			arcShape.y = stage.stageHeight >> 1;
			addChild(arcShape);
			
			arcStartControl.graphics.beginFill(0);
			arcStartControl.graphics.drawCircle(0, 0, 5);
			arcStartControl.graphics.endFill();
			arcStartControl.x = arcStartPoint.x + (stage.stageWidth >> 1);
			arcStartControl.y = arcStartPoint.y + (stage.stageHeight >> 1);
			arcStartControl.buttonMode = true;
			addChild(arcStartControl);
			
			arcEndControl.graphics.beginFill(0);
			arcEndControl.graphics.drawCircle(0, 0, 5);
			arcEndControl.graphics.endFill();
			arcEndControl.x = arcEndPoint.x + (stage.stageWidth >> 1);
			arcEndControl.y = arcEndPoint.y + (stage.stageHeight >> 1);
			arcEndControl.buttonMode = true;
			addChild(arcEndControl);
			
			stage_mouseMove(null);
			
			arcStartText.text = "start";
			arcEndText.text = "end";
			addChild(arcEndText);
			addChild(arcStartText);
			
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			arcStartControl.addEventListener(MouseEvent.MOUSE_DOWN, control_mouseDown);
			arcEndControl.addEventListener(MouseEvent.MOUSE_DOWN, control_mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		}
		
		private function this_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			arcStartControl.removeEventListener(MouseEvent.MOUSE_DOWN, control_mouseDown);
			arcEndControl.removeEventListener(MouseEvent.MOUSE_DOWN, control_mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		}
		
		private var dragging:Sprite;
		
		private function control_mouseDown(e:MouseEvent):void
		{
			dragging = e.target as Sprite;
			dragging.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		}
		
		private function stage_mouseMove(e:MouseEvent):void
		{
			var mouseVector:Vector2D = new Vector2D(mouseX - (stage.stageWidth >> 1), mouseY - (stage.stageHeight >> 1));
			mouseVector.length(150);
			if (dragging != null)
			{
				dragging.x = mouseVector.x + (stage.stageWidth >> 1);
				dragging.y = mouseVector.y + (stage.stageHeight >> 1);
				
				if (dragging == arcStartControl)
					angleStart = mouseVector.angle();
				else
					angleEnd = mouseVector.angle();
			} else {
				angleStart = new Vector2D(arcStartControl.x - (stage.stageWidth >> 1), arcStartControl.y - (stage.stageHeight >> 1)).angle();
				angleEnd = new Vector2D(arcEndControl.x - (stage.stageWidth >> 1), arcEndControl.y - (stage.stageHeight >> 1)).angle();
			}
			
			arcShape.graphics.clear();
			arcShape.graphics.lineStyle(1);
			arcShape.graphics.moveTo(0, 0);
			arcShape.graphics.lineTo(arcStartControl.x - (stage.stageWidth >> 1), arcStartControl.y - (stage.stageHeight >> 1));
			arcShape.graphics.moveTo(0, 0);
			arcShape.graphics.lineTo(arcEndControl.x - (stage.stageWidth >> 1), arcEndControl.y - (stage.stageHeight >> 1));
			drawArc(arcShape.graphics, new Point2D(), angleStart, angleEnd, 100);
			
			arcStartText.x = arcStartControl.x + 10;
			arcStartText.y = arcStartControl.y -10;
			arcEndText.x = arcEndControl.x + 10;
			arcEndText.y = arcEndControl.y - 10;
		}
		
		private function stage_mouseUp(e:MouseEvent):void
		{
			arcStartControl.stopDrag();
			arcEndControl.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		}
		
		
	}
}