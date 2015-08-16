package net.avdw.gui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.text.TextField;
	import net.avdw.demo.curve.DemoCurveContinuity;
	import net.avdw.graphics.DrawingShapes;
	import net.avdw.math.MathConstant;
	import net.avdw.math.Vector2D;
	
	/**
	 * https://dribbble.com/shots/801609-Concept-Idea-Radial-Menu-UI-animated
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiRadialMenu extends Sprite
	{
		private const sliceModels:Vector.<GuiMenuItem> = new Vector.<GuiMenuItem>;
		private const sliceViews:Vector.<GuiRadialSliceView> = new Vector.<GuiRadialSliceView>;
		private const title:TextField = new TextField;
		
		public function GuiRadialMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function add(guiMenuItem:GuiMenuItem):void
		{
			sliceModels.push(guiMenuItem);
		}
		
		private function renderView():void
		{
			const radiusInner:int = 75;
			const radiusOuter:int = 125;
			graphics.clear();
			graphics.lineStyle(1);
			
			const sliceLength:Number = MathConstant.TWO_PI / sliceModels.length;
			var sliceMarker:Number = 0, i:int = 0;
			while (sliceMarker < MathConstant.TWO_PI)
			{
				const sliceView:GuiRadialSliceView = new GuiRadialSliceView(sliceMarker, sliceMarker += sliceLength, radiusInner, radiusOuter, sliceModels[i++]);
				sliceViews.push(sliceView);
				addChild(sliceView);
			}
		
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			renderView();
			addChild(title);
			visible = false;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
		
		private function this_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUp);
		}
		
		private function stage_mouseDown(e:MouseEvent):void
		{
			x = stage.mouseX;
			y = stage.mouseY;
			
			visible = true;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		}
		
		private function stage_mouseMove(e:MouseEvent):void
		{
			const angle:Number = Math.atan2(-stage.mouseY + y, -stage.mouseX + x) + Math.PI;
			var count:int = 0;
			for each (var sliceView:GuiRadialSliceView in sliceViews)
			{
				if (sliceView.containsAngle(angle))
				{
					sliceView.focus(angle);
					//title.text = sliceView.focusTitle;
					title.text = sliceModels[count].name;
				}
				else
				{
					sliceView.noFocus();
				}
				count++;
			}
		}
		
		private function stage_mouseUp(e:MouseEvent):void
		{
			visible = false;
			
			// fire event for selected slice			
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMove);
		}
	
	}

}

import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import net.avdw.graphics.drawArc;
import net.avdw.math.Point2D;
import net.avdw.math.Vector2D;
import net.avdw.gui.GuiMenuItem;

class GuiRadialSliceView extends Sprite
{
	private const subsliceModels:Vector.<GuiMenuItem> = new Vector.<GuiMenuItem>;
	private const subsliceViews:Vector.<GuiRadialSliceView> = new Vector.<GuiRadialSliceView>;
	public var model:GuiMenuItem;
	public var radiusInner:Number;
	public var radiusOuter:Number;
	public var hasFocus:Boolean = false;
	public var angleStart:Number;
	public var angleEnd:Number;
	
	public function GuiRadialSliceView(angleStart:Number, angleEnd:Number, radiusInner:Number, radiusOuter:Number, model:GuiMenuItem)
	{
		this.model = model;
		this.radiusOuter = radiusOuter;
		this.radiusInner = radiusInner;
		this.angleStart = angleStart;
		this.angleEnd = angleEnd;
		
		graphics.lineStyle(1);
		graphics.beginFill(0x333333);
		drawArc(graphics, new Point2D, angleStart, angleEnd, radiusOuter);
		drawArc(graphics, new Point2D, angleStart, angleEnd, radiusInner, true, true);
		graphics.endFill();
		
		if (model != null && model.children != null && model.children.length > 0)
		{
			const subsliceLength:Number = (angleEnd - angleStart) / model.children.length;
			var subsliceMarker:Number = angleStart;
			for (var i:int = 0; i < model.children.length; i++)
			{
				const subsliceView:GuiRadialSliceView = new GuiRadialSliceView(subsliceMarker, subsliceMarker += subsliceLength, radiusInner, radiusOuter, null);
				subsliceView.visible = false;
				subsliceViews.push(subsliceView);
				addChild(subsliceView);
			}
		}
	}
	
	public function add(menuItem:GuiMenuItem):void
	{
		subsliceModels.push(menuItem);
	}
	
	public function containsAngle(angle:Number):Boolean
	{
		return angle > angleStart && angle < angleEnd;
	}
	
	public function focus(angle:Number):void
	{
		if (model != null && model.children != null && model.children.length > 0)
			for each (var subsliceView:GuiRadialSliceView in subsliceViews) {
				subsliceView.visible = true;
				if (subsliceView.containsAngle(angle))
					subsliceView.focus(angle);
				else
					subsliceView.noFocus();
			}
		else
			filters = [new GlowFilter(0xFFFFFF, 1, 6, 6, 2, 1, true)];
		
		hasFocus = true;
	}
	
	public function noFocus():void
	{
		filters = [];
		for each (var subsliceView:GuiRadialSliceView in subsliceViews) {
			subsliceView.filters = [];
			subsliceView.visible = false;
		}
		
		hasFocus = false;
	}
	
	override public function toString():String
	{
		return "slice{start:%1, end:%2}".replace("%1", angleStart).replace("%2", angleEnd);
	}
}