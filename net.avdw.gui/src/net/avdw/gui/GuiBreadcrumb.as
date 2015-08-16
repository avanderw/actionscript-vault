package net.avdw.gui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import net.avdw.align.spaceHorizontal;
	import net.avdw.font.FontConsolas;
	import net.avdw.suite.SuitePage;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiBreadcrumb extends Sprite
	{
		public const items:Vector.<GuiBreadcrumbItem> = new Vector.<GuiBreadcrumbItem>;
		private var callback:Function;
		
		public function GuiBreadcrumb()
		{
			if (stage)
				this_addedToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function set page(page:SuitePage):void
		{
			var item:GuiBreadcrumbItem;
			for each (item in items)
			{
				item.removeEventListener(MouseEvent.CLICK, guiBreadcrumbItem_clicked);
				removeChild(item);
			}
			items.splice(0, items.length);
			
			const pages:Vector.<SuitePage> = new Vector.<SuitePage>;
			var currPage:SuitePage = page;
			while (currPage.parent != null)
			{
				pages.push(currPage);
				currPage = currPage.parent;
			}
			pages.push(currPage);
			
			pages.reverse();
			for each (var breadcrumb:SuitePage in pages)
			{
				items.push(new GuiBreadcrumbItem(breadcrumb, breadcrumb.title, breadcrumb.children.length));
				const lastItem:GuiBreadcrumbItem = items[items.length - 1];
				lastItem.addEventListener(MouseEvent.CLICK, guiBreadcrumbItem_clicked);
				addChild(lastItem);
				
				if (items.length > 1)
				{
					const secondLastItem:GuiBreadcrumbItem = items[items.length - 2];
					lastItem.x = secondLastItem.x + secondLastItem.width - (lastItem.height>>1);
				}
			}
			lastItem.removeEventListener(MouseEvent.CLICK, guiBreadcrumbItem_clicked);
			
			for each (item in items)
			{
				item.update();
			}
		}
		
		public function onClicked(callback:Function):void
		{
			this.callback = callback;
		}
		
		private function this_addedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			filters = [new DropShadowFilter()];
		}
		
		private function guiBreadcrumbItem_clicked(e:MouseEvent):void
		{
			const guiBreadcrumbItem:GuiBreadcrumbItem = e.currentTarget as GuiBreadcrumbItem;
			callback.call(null, guiBreadcrumbItem.page);
		}
	
	}

}