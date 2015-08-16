package net.avdw.gui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import net.avdw.font.*;
	
	public class UrlWatcher extends Sprite
	{
		private const urlLoader:URLLoader = new URLLoader();
		private const urlRequest:URLRequest = new URLRequest();
		private const timer:Timer = new Timer(30000, 1);
		
		private const text:TextField = new TextField();
		private const green:Sprite = new Sprite();
		private const red:Sprite = new Sprite();
		private const orange:Sprite = new Sprite();
		private const blue:Sprite = new Sprite();
		
		private var startTime:uint;
		private var url:String;
		
		[Event(name="Event.CHANGE", type="flash.events.Event")]
		
		public function UrlWatcher(url:String, name:String = null)
		{
			this.name = name;
			urlRequest.url = this.url = url;
			
			urlLoader.addEventListener(Event.COMPLETE, complete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, security);
			
			text.defaultTextFormat = new TextFormat(FontConsolas.NAME, 10, 0, null, null, null, url);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.selectable = false;
			text.embedFonts = true;
			refreshText();
			text.x = text.height;
			
			green.y = orange.y = red.y = 2;
			
			fillCircle(green.graphics, 0x00FF00);
			fillCircle(red.graphics, 0xFF0000);
			fillCircle(orange.graphics, 0xFFCC00);
			fillCircle(blue.graphics, 0x0000FF);
			
			addChild(orange);
			addChild(text);
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, check);
			check();
		}
		
		private function refreshText():void
		{
			text.text = name ? name : "";
			text.appendText(" (" + url + ")");
			
			if (startTime)
				text.appendText(" [" + (getTimer() - startTime) + "ms]");
				
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function check(e:TimerEvent = null):void
		{
			startTime = getTimer();
			urlLoader.load(urlRequest);
			addChild(orange);
		}
		
		private function security(e:SecurityErrorEvent):void 
		{
			refreshText();
			addChild(blue);
			timer.start();
		}
		
		private function error(e:Event):void
		{
			refreshText();
			addChild(red);
			timer.start();
		}
		
		private function complete(e:Event):void
		{
			refreshText();
			addChild(green);
			
			var data:String = urlLoader.data;
			if (data.search(/.*not available.*/) >= 0 ) {
				addChild(red);
			}
			
			timer.start();
		}
		
		private function fillCircle(graphics:Graphics, color:uint):void
		{
			graphics.beginFill(color);
			graphics.drawCircle(text.height / 2, text.textHeight / 2, text.textHeight / 2);
			graphics.endFill();
		}
	
	}
}