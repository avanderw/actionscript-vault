package net.avdw.gui.decorator
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.avdw.type.EDirection;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DecorateCollapsable extends Sprite
	{
		private var displayObject:DisplayObject;
		private var collapseDirection:EDirection;
		
		public function DecorateCollapsable(displayObject:DisplayObject, collapseDirection:EDirection)
		{
			this.displayObject = displayObject;
			this.collapseDirection = collapseDirection;
			
			if (displayObject.parent == null)
				displayObject.addEventListener(Event.ADDED_TO_STAGE, displayObject_addedToStage);
			else
				displayObject_addedToStage();
		}
		
		private function displayObject_addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, displayObject_addedToStage);
			
			displayObject.parent.addChild(this);
			addChild(displayObject);
			
			addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
		}
		
		private function _removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
			displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, _removedFromStage);
			
			if (parent != null)
				parent.removeChild(this);
		}
	
	}

}