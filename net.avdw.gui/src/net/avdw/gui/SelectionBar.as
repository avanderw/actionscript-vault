package net.avdw.gui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.avdw.align.*;
	import net.avdw.display.addChildrenTo;
	import net.avdw.font.*;
	import org.osflash.signals.Signal;
	
	public class SelectionBar extends Sprite
	{
		private const format:TextFormat = new TextFormat(FontConsolas.NAME, 10);
		
		protected const selectedText:TextField = new TextField;
		protected const nextBtn:TextField = new TextField;
		protected const prevBtn:TextField = new TextField;
		
		protected var items:Array = new Array;
		protected var index:int = 0;
		
		public const onChange:Signal = new Signal();
		
		public function SelectionBar(... args)
		{
			add.apply(this, args);
			
			setupTextFields(prevBtn, selectedText, nextBtn);
			addChildrenTo(this, prevBtn, selectedText, nextBtn);
			
			nextBtn.text = ">>";
			prevBtn.text = "<<";
			
			addEventListener(Event.ADDED_TO_STAGE, setup);
		}
		
		public function add(... args):SelectionBar
		{
			var item:*;
			switch (args.length)
			{
				case 1: 
					if (args[0].hasOwnProperty("length"))
						for each (item in args[0])
							items.push(item);
					else
						items.push(args[0]);
					break;
				
				case 0: 
				default: 
					for each (item in args)
						items.push(item);
					break;
			}
			
			refresh();
			return this;
		}
		
		public function get selected():* {
			return items[index];
		}
		
		private function next(e:Event = null):*
		{
			index = ++index % items.length;
			return refresh();
		}
		
		private function prev(e:Event = null):*
		{
			if (--index < 0)
				index = items.length - 1;
			
			return refresh();
		}
		
		private function setup(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, setup);
			
			nextBtn.addEventListener(MouseEvent.CLICK, next);
			prevBtn.addEventListener(MouseEvent.CLICK, prev);
		}
		
		private function setupTextFields(... args):void
		{
			for each (var textField:TextField in args)
			{
				textField.embedFonts = true;
				textField.defaultTextFormat = format;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
				textField.background = true;
				textField.backgroundColor = 0xFFFFFF;
			}
		}
		
		private function refresh():*
		{
			if (items.length == 0)
				return;
			
			selectedText.text = items[index].name;
			spaceHorizontal(1, prevBtn, selectedText, nextBtn); // TODO space to the largest width item
			
			onChange.dispatch(items[index]);
			
			return items[index];
		}
	}
}