package net.avdw.demo.particle
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.avdw.curve.CurveButterfly;
	import net.avdw.demo.ADemo;
	import net.avdw.text.loadText;
	import net.avdw.background.bgFromCode;
	import net.avdw.math.Point2D;
	import net.avdw.math.Range;
	import net.hires.debug.Stats;
	
	public class FairyDustDemo extends ADemo
	{
		private const leadingLine:Sprite = new Sprite();
		
		private var fairy1:Fairy;
		private var fairy2:Fairy;
		private var fairy3:Fairy;
		private var center:Point2D;
		private var t:Number = 0;
		private var butterflyCurve:CurveButterfly;
		
		public var followingMouse:Boolean = false;
		
		public function FairyDustDemo()
		{
			if (stage)
				load();
			else
				addEventListener(Event.ADDED_TO_STAGE, load);
		}
		
		private function load(e:Event = null):void
		{
			[Embed(source="FairyDustDemo.as",mimeType="application/octet-stream")]
			const TextFile:Class;
			addChild(bgFromCode(stage.stageWidth, stage.stageHeight, TextFile));
			
			center = new Point2D(stage.stageWidth / 2, stage.stageHeight / 2);
			
			fairy1 = new Fairy(center);
			fairy2 = new Fairy(center);
			fairy3 = new Fairy(center);
			
			addChild(leadingLine);
			addChild(fairy1);
			addChild(fairy2);
			addChild(fairy3);
			
			butterflyCurve = new CurveButterfly();
			butterflyCurve.x = center.x;
			butterflyCurve.y = center.y;
			butterflyCurve.alpha = .25;
			addChild(butterflyCurve);
			fadeOutButterfly();
			
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					followingMouse = true;
				});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void
				{
					followingMouse = false
				});
		}
		
		private function fadeOutButterfly():void
		{
			TweenLite.to(butterflyCurve, 2, {alpha: .05, onComplete: function():void
				{
					TweenLite.to(butterflyCurve, 2, {alpha: .25, onComplete: fadeOutButterfly})
				}});
		}
		
		private function update(event:Event):void
		{
			t = t > CurveButterfly.PERIOD ? 0 : t + .05;
			var point:Point2D = CurveButterfly.point(t);
			point.add(center);
			
			var springPoint:Point2D = followingMouse ? new Point2D(stage.mouseX, stage.mouseY) : point;
			fairy1.physics.springTo(springPoint);
			fairy2.physics.springTo(fairy1);
			fairy3.physics.springTo(fairy2);
			
			leadingLine.graphics.clear();
			leadingLine.graphics.lineStyle(1, 0x666666);
			leadingLine.graphics.moveTo(fairy1.x, fairy1.y);
			leadingLine.graphics.lineTo(springPoint.x, springPoint.y);
			leadingLine.graphics.beginFill(0x666666);
			leadingLine.graphics.drawCircle(springPoint.x, springPoint.y, 3);
			leadingLine.graphics.endFill();
		}
	}
}

import com.greensock.TweenLite;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import net.avdw.math.Point2D;
import net.avdw.math.Range;
import net.avdw.math.Vector2D;
import net.avdw.component.PhysicsComponent;
import net.avdw.random.randomBoolean;
import net.avdw.random.randomNumber;
import net.avdw.random.randomOffsetFrom;

class Fairy extends Sprite
{
	public const physics:PhysicsComponent = new PhysicsComponent(this);
	
	public function Fairy(... args)
	{
		graphics.beginFill(0xe3f23e);
		graphics.drawCircle(0, 0, 10);
		graphics.endFill();
		
		filters = [new BlurFilter(10, 10, 3)];
		
		physics.position.set.apply(this, args);
		physics.friction.set(.8, .8);
		physics.spring.set(.075, .075);
		addEventListener(Event.ENTER_FRAME, physics.update);
		
		addEventListener(Event.ENTER_FRAME, update);
		addEventListener(Event.REMOVED_FROM_STAGE, unload);
	}
	
	private function update(event:Event):void
	{
		for (var i:Number = 0; i < 3; i++)
			parent.addChildAt(new FairyDust(physics.position, physics.velocity.clone().scale(.2)), 1);
	}
	
	private function unload(event:Event = null):void
	{
		removeEventListener(Event.REMOVED_FROM_STAGE, unload);
		removeEventListener(Event.ENTER_FRAME, update);
		removeEventListener(Event.ENTER_FRAME, physics.update);
	}

}

class FairyDust extends Sprite
{
	public const physics:PhysicsComponent = new PhysicsComponent(this);
	
	public function FairyDust(position:Point2D, velocity:Vector2D):void
	{
		graphics.clear();
		graphics.beginFill(0xa6a53f);
		graphics.drawCircle(0, 0, 4);
		graphics.drawCircle(0, 0, 2);
		graphics.endFill();
		
		if (randomBoolean(.25))
			scaleX = scaleY = Math.random() * 2 + 1;
		
		var scaleTo:Number = randomNumber(.5, 1.6);
		TweenLite.to(this, randomNumber(.5, 1.6), {alpha: 0, scaleX: scaleTo, scaleY: scaleTo, onComplete: unload})
		
		physics.position.set(position);
		physics.velocity.set(velocity);
		physics.velocity.length(randomOffsetFrom(physics.velocity.length(), 2, 5, false));
		physics.velocity.rotate(randomOffsetFrom(0, Math.PI / 3));
		addEventListener(Event.ENTER_FRAME, physics.update);
	}
	
	private function unload(event:Event = null):void
	{
		this.parent.removeChild(this);
		removeEventListener(Event.ENTER_FRAME, physics.update);
	}
}