package net.avdw.gui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import net.avdw.decoration.wallpaper.WallpaperMarble015;
	import net.avdw.decoration.wallpaper.WallpaperMarble016;
	import net.avdw.font.FontConsolas;
	import net.avdw.font.FontFatalFuryOutline;
	import net.avdw.font.FontFipps;
	import net.avdw.font.FontMarioKartDs;
	import net.avdw.font.FontO4b03;
	import net.avdw.font.FontO4b30;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiPanel extends Sprite
	{
		static private const PADDING:int = 5;
		private var desiredWidth:int;
		private var desiredHeight:int;
		private var panelTitle:String;
		private var back:Shape;
		private var front:Shape;
		private var backBorder:Shape;
		private var frontBorder:Shape;
		
		private const renderBitmap:Bitmap = new Bitmap();
		private var isRenderDirty:Boolean = true;
		private var style:GuiStyle;
		
		public function GuiPanel(title:String = "", style:GuiStyle = null, desiredWidth:int = 0, desiredHeight:int = 0)
		{
			this.style = style;
			panelTitle = title;
			this.desiredHeight = desiredHeight;
			this.desiredWidth = desiredWidth;
			
			addChild(renderBitmap);
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		public function addDisplayObject(displayObject:DisplayObject):void
		{
			displayObject.x = 2 * PADDING;
			displayObject.y = 4 * PADDING;
			addChild(displayObject);
			isRenderDirty = true;
			render();
		}
		
		private function render():void
		{
			const panelWidth:int = Math.max(desiredWidth, width + 2 * PADDING);
			const panelHeight:int = Math.max(desiredHeight, height + 2 * PADDING);
			
			back = WallpaperMarble015.create(panelWidth, panelHeight, 20);
			back.filters = [new BevelFilter(3, 45, 0xffffff, 1, 0x333333)];
			
			front = WallpaperMarble016.create(panelWidth - 2 * PADDING, panelHeight - 2 * PADDING, 15);
			front.filters = [new BevelFilter(2, 45, 0xffffff, 1, 0x333333)];
			front.x = front.y = PADDING;
			
			backBorder = new Shape();
			backBorder.graphics.lineStyle(1, 0x333333);
			backBorder.graphics.drawRoundRect(0, 0, back.width, back.height, 20);
			
			frontBorder = new Shape();
			frontBorder.graphics.lineStyle(1, 0x666666);
			frontBorder.graphics.drawRoundRect(PADDING, PADDING, front.width, front.height, 15);
			
			const container:Sprite = new Sprite();
			container.addChild(back);
			container.addChild(front);
			container.addChild(backBorder);
			container.addChild(frontBorder);
			
			if (panelTitle != null && panelTitle.length > 0)
			{
				const _title:TextField = FontO4b30.createTextfied(panelTitle, 12, 0xFFFFFF);
				_title.filters = [new GlowFilter(0, 1, 2, 2, 100)];
				_title.x += 15;
				_title.y += 1;
				container.addChild(_title);
			}
			
			renderBitmap.bitmapData = new BitmapData(container.width, container.height, true, 0);
			renderBitmap.bitmapData.draw(container);
			
			isRenderDirty = false;
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			addEventListener(Event.ENTER_FRAME, this_enterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
		
		private function this_removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			removeEventListener(Event.ENTER_FRAME, this_enterFrame);
		}
		
		private function this_enterFrame(e:Event):void
		{
			if (isRenderDirty)
				render();
		}
	
	}

}