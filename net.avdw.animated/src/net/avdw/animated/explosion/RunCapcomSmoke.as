package net.avdw.animated.explosion
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.math.Vector2D;
	
	public class RunCapcomSmoke extends Sprite
	{
		
		public function RunCapcomSmoke()
		{
			addEventListener(Event.ENTER_FRAME, startup);
		}
		
		private function startup(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, startup);
			
			var guiArc:GuiArc = new GuiArc(new Vector2D(50, 50), Math.PI / 3);
			guiArc.x = stage.stageWidth / 2;
			guiArc.y = stage.stageHeight / 2;
			addChild(guiArc);
		}
	}
}

import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import net.avdw.generated.draw.drawArc;
import net.avdw.math.Point2D;
import net.avdw.math.Vector2D;

class GuiArc extends Sprite
{
	public const directionVector:Vector2D = new Vector2D;
	public const maxVector:Vector2D = new Vector2D;
	public const minVector:Vector2D = new Vector2D;
	public var deviation:Number;
	
	private const directionControl:Sprite = new Sprite;
	private const minControl:Sprite = new Sprite;
	private const maxControl:Sprite = new Sprite;
	
	public function GuiArc(directionVector:Vector2D, deviation:Number)
	{
		this.directionVector.set(directionVector);
		this.deviation = deviation;
		
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event = null):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		initControl(directionControl);
		initControl(maxControl);
		initControl(minControl);
		
		refreshVectors();
		updateControls();
		render();
		
		addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				var mouse:Point = globalToLocal(new Point(mouseX, mouseY));
				if ((mouse.x + x) * (mouse.x + x) + (mouse.y + y) * (mouse.y + y) - 7500 < directionVector.lengthSqr())
					alpha = Math.min(1, alpha + .1);
				else
					alpha = Math.max(.35, alpha - .1);
			});
		
		addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		stage.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		directionControl.addEventListener(MouseEvent.MOUSE_DOWN, startDirectionControl);
		minControl.addEventListener(MouseEvent.MOUSE_DOWN, startMinVectorControl);
		maxControl.addEventListener(MouseEvent.MOUSE_DOWN, startMaxVectorControl);
	}
	
	private function initControl(control:Sprite):void
	{
		control.graphics.beginFill(0);
		control.graphics.drawCircle(0, 0, 3);
		control.graphics.endFill();
		control.alpha = 0;
		
		control.hitArea = new Sprite();
		control.hitArea.graphics.beginFill(0);
		control.hitArea.graphics.drawCircle(0, 0, 10);
		control.hitArea.graphics.endFill();
		control.hitArea.mouseEnabled = false;
		control.hitArea.visible = false;
		
		addChild(control.hitArea);
		addChild(control);
		
		control.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				var mouse:Point = control.globalToLocal(new Point(mouseX, mouseY));
				if ((mouseX - control.x) * (mouseX - control.x) + (mouseY - control.y) * (mouseY - control.y) <  7500)
					control.alpha = Math.min(1, control.alpha + .1);
				else
					control.alpha = Math.max(0, control.alpha - .1);
			});
		
		control.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
	}
	
	private function refreshVectors():void
	{
		minVector.set(directionVector);
		maxVector.set(directionVector);
		
		minVector.rotate(-deviation);
		maxVector.rotate(deviation);
	}
	
	private function startDragging(e:MouseEvent = null):void
	{
		e.target.startDrag();
	}
	
	private function stopDragging(e:MouseEvent):void
	{
		directionControl.stopDrag();
		maxControl.stopDrag();
		minControl.stopDrag();
		
		refreshVectors();
		updateControls();
		render();
		
		removeEventListener(Event.ENTER_FRAME, refreshVectors);
		removeEventListener(Event.ENTER_FRAME, render);
		directionControl.removeEventListener(Event.ENTER_FRAME, updateDirectionVector);
		minControl.removeEventListener(Event.ENTER_FRAME, updateMinVector);
		maxControl.removeEventListener(Event.ENTER_FRAME, updateMaxVector);
	}
	
	private function updateMaxVector(e:Event):void
	{
		maxVector.x = maxControl.x;
		maxVector.y = maxControl.y;
		
		deviation = directionVector.angleBetween(maxVector);
		directionVector.length(maxVector.length());
		
		refreshVectors();
		updateControls();
		render();
	}
	
	private function updateMinVector(e:Event):void
	{
		minVector.x = minControl.x;
		minVector.y = minControl.y;
		
		deviation = minVector.angleBetween(directionVector);
		directionVector.length(minVector.length());
		
		refreshVectors();
		updateControls();
		render();
	}
	
	private function updateDirectionVector(e:Event):void
	{
		directionVector.x = directionControl.x;
		directionVector.y = directionControl.y;
		
		refreshVectors();
		updateControls();
		render();
	}
	
	private function destroy(e:Event):void
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
	}
	
	private function startMaxVectorControl(e:MouseEvent):void
	{
		maxControl.addEventListener(Event.ENTER_FRAME, updateMaxVector);
	}
	
	private function startMinVectorControl(e:MouseEvent):void
	{
		minControl.addEventListener(Event.ENTER_FRAME, updateMinVector);
	}
	
	private function startDirectionControl(e:MouseEvent):void
	{
		directionControl.addEventListener(Event.ENTER_FRAME, updateDirectionVector);
	}
	
	private function render(e:Event = null):void
	{
		graphics.clear();
		
		graphics.lineStyle(1);
		graphics.lineTo(directionVector.x, directionVector.y);
		
		graphics.moveTo(0, 0);
		graphics.lineTo(maxVector.x, maxVector.y);
		
		graphics.moveTo(0, 0);
		graphics.lineTo(minVector.x, minVector.y);
		
		drawArc(graphics, new Point2D, minVector.angle(), maxVector.angle(), directionVector.length());
	}
	
	private function updateControls():void
	{
		directionControl.x = directionVector.x;
		directionControl.y = directionVector.y;
		directionControl.hitArea.x = directionControl.x;
		directionControl.hitArea.y = directionControl.y;
		
		minControl.x = minVector.x;
		minControl.y = minVector.y;
		minControl.hitArea.x = minControl.x;
		minControl.hitArea.y = minControl.y;
		
		maxControl.x = maxVector.x;
		maxControl.y = maxVector.y;
		maxControl.hitArea.x = maxControl.x;
		maxControl.hitArea.y = maxControl.y;
	}
}