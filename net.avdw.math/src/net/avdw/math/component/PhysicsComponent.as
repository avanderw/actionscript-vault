package net.avdw.component
{
	import flash.events.Event;
	import net.avdw.math.Point2D;
	import net.avdw.math.Vector2D;
	
	/**
	 * This component class will update it's parent's x & y properties.
	 * It contains basic physics capabilities to modify the parent's position.
	 * It will automatically update the parent's position whenever the position updates.
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class PhysicsComponent
	{
		public const position:Point2D = new Point2D();
		public const velocity:Vector2D = new Vector2D();
		public const acceleration:Vector2D = new Vector2D();
		public const friction:Vector2D = new Vector2D(1, 1);
		public const spring:Vector2D = new Vector2D(1, 1);
		public const ease:Vector2D = new Vector2D(1, 1);
		
		protected var parent:Object;
		
		/**
		 * @param	parent	Object to update when the position changes
		 */
		public function PhysicsComponent(parent:Object)
		{
			this.parent = parent;
			position.onUpdate.add(updateParent);
		}
		
		private function updateParent():void 
		{
			parent.x = position.x;
			parent.y = position.y;
		}
		
		public function update(e:Event = null):void
		{
			velocity.add(acceleration);
			velocity.multiply(friction);
			position.add(velocity);
		}
		
		public function springTo(... args):PhysicsComponent
		{
			acceleration.set.apply(this, args);
			acceleration.subtract(position);
			acceleration.multiply(spring);
			return this;
		}
		
		public function easeTo(... args):PhysicsComponent {
			velocity.set.apply(this, args);
			velocity.subtract(position);
			velocity.multiply(ease);
			return this;
		}
	}
}