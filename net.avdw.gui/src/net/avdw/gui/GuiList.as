package net.avdw.gui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import net.avdw.align.spaceVertical;
	
	/**
	 * http://www.premiumpixels.com/freebies/vertical-navigation-menu-psd/
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiList extends Sprite
	{
		public const items:Vector.<GuiListItem> = new Vector.<GuiListItem>;
		private var callback:Function;
		private var desiredWidth:int;
		
		public function GuiList(desiredWidth:int = 0)
		{
			this.desiredWidth = desiredWidth;
			
			if (stage)
				this_addedToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			filters = [new DropShadowFilter()];
		}
		
		public function onClicked(callback:Function):void
		{
			this.callback = callback;
		}
		
		public function clear():void
		{
			for each (var item:GuiListItem in items)
			{
				item.mask = null;
				item.removeEventListener(MouseEvent.CLICK, guiListItem_clicked);
				removeChild(item);
			}
			
			items.splice(0, items.length);
			render();
		}
		
		public function add(guiListItem:GuiListItem):void
		{
			guiListItem.addEventListener(MouseEvent.CLICK, guiListItem_clicked);
			items.push(guiListItem);
			
			spaceVertical(items);
			addChild(guiListItem);
			render();
		}
		
		private function render():void
		{		
			graphics.clear();
			graphics.lineTo(desiredWidth, 0);
			for each (var item:GuiListItem in items) {
				item.update();
			}
		}
		
		private function guiListItem_clicked(e:MouseEvent):void
		{
			if (callback == null) 
				return;
			
			const guiListItem:GuiListItem = e.currentTarget as GuiListItem;
			callback.call(null, guiListItem.data);
		}
	
	}

}