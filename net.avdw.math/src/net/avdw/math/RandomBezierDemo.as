package
{
	import fl.motion.BezierSegment;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import net.avdw.graphics.drawBezierCurve;
	import net.avdw.math.Vec2;
	import net.avdw.number.SeededRNG;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RandomBezierDemo extends Sprite
	{
		private var beziers:Array = [];
		private var velocities:Array = [];
		
		private var speed:int = 2;
		private var numBeziers:int = 3;
		
		public function RandomBezierDemo()
		{
			for (var i:int = 0; i < numBeziers; i++)
			{
				beziers.push(createBezier());
				velocities.push(createVelocity());
			}
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void
		{
			graphics.clear();
			graphics.lineStyle(1);
			
			for (var i:int = 0; i < numBeziers; i++)
			{
				modCurve(beziers[i], velocities[i]);
				drawBezierCurve(beziers[i][0], beziers[i][1], beziers[i][2], beziers[i][3], graphics);
			}
		}
		
		private function createVelocity():Array
		{
			var velocity:Array = [];
			velocity.push(new Vec2(SeededRNG.sign() * speed, SeededRNG.sign() * speed));
			velocity.push(new Vec2(SeededRNG.sign() * speed, SeededRNG.sign() * speed));
			velocity.push(new Vec2(SeededRNG.sign() * speed, SeededRNG.sign() * speed));
			velocity.push(new Vec2(SeededRNG.sign() * speed, SeededRNG.sign() * speed));
			return velocity;
		}
		
		private function createBezier():Array
		{
			var bezier:Array = [];
			bezier.push(new Point(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight));
			bezier.push(new Point(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight));
			bezier.push(new Point(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight));
			bezier.push(new Point(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight));
			return bezier;
		}
		
		private function modCurve(bezier:Array, velocity:Array):void
		{
			modVelocity(velocity[0]);
			modVelocity(velocity[1]);
			modVelocity(velocity[2]);
			modVelocity(velocity[3]);
			
			movePoint(bezier[0], velocity[0]);
			movePoint(bezier[1], velocity[1]);
			movePoint(bezier[2], velocity[2]);
			movePoint(bezier[3], velocity[3]);
		}
		
		private function modVelocity(endPoint1Velocity:Vec2):void
		{
			if (SeededRNG.boolean(.1))
				endPoint1Velocity.rotateSelf(SeededRNG.float(-Math.PI / 12, Math.PI / 12));
		}
		
		private function movePoint(endPoint1:Point, endPoint1Velocity:Vec2):void
		{
			endPoint1.x += endPoint1Velocity.x;
			endPoint1.y += endPoint1Velocity.y;
			
			bound(endPoint1, endPoint1Velocity);
		}
		
		private function bound(endPoint1:Point, endPoint1Velocity:Vec2):void
		{
			if (endPoint1.x < 0 || endPoint1.x > stage.stageWidth)
				endPoint1Velocity.x = -endPoint1Velocity.x;
			if (endPoint1.y < 0 || endPoint1.y > stage.stageHeight)
				endPoint1Velocity.y = -endPoint1Velocity.y;
		}
	
	}

}