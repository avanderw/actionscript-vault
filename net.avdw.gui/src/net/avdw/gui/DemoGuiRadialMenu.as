package net.avdw.demo
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.avdw.decoration.wallpaper.*;
	import net.avdw.gui.*;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class DemoGuiRadialMenu extends Sprite
	{
		
		private const menu:GuiRadialMenu = new GuiRadialMenu();
		
		public function DemoGuiRadialMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			addChild(WallpaperMottled040.create(stage.stageWidth, stage.stageHeight));
			
			menu.add(new GuiMenuItem("Cubic", null, [new GuiMenuItem("EaseIn"), new GuiMenuItem("EaseInOut"), new GuiMenuItem("EaseOut")]));
			menu.add(new GuiMenuItem("Quint", null, [new GuiMenuItem("EaseIn"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut")]));
			menu.add(new GuiMenuItem("Expo", null, [new GuiMenuItem("EaseIn"), new GuiMenuItem("EaseInOut")]));
			menu.add(new GuiMenuItem("Quart", null, [new GuiMenuItem("EaseIn"), new GuiMenuItem("EaseInOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut"), new GuiMenuItem("EaseOut")]));
			menu.add(new GuiMenuItem("Expo"));
			addChild(menu);
			
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			
		}
		
		private function this_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
	
	}

}