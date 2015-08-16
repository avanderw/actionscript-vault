package net.avdw.demo
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import net.avdw.font.FontConsolas;
	import net.avdw.object.randomKeyFrom;
	import net.avdw.random.randomWordsFromMarkovChain;
	import net.avdw.stats.markovChainFromText;
	import net.avdw.stats.markovChainFromTitles;
	import net.avdw.text.loadLinesFromTextFile;
	import uk.co.soulwire.gui.SimpleGUI;
	
	public class MarkovChainDemo extends Sprite
	{
		[Embed(source="../../../../resource/text/movie-titles.txt", mimeType = "application/octet-stream")]
		private const TextFile:Class;
		private var chain:Object;
		private var text:TextField;
		
		public var chainOrder:int = 2;
		public var titleLength:int = 7;
		
		public function MarkovChainDemo()
		{
			if (stage)
				start();
			else
				addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, start);
			addEventListener(Event.ENTER_FRAME, buildChain);
			
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addStepper("chainOrder", 1, 5, { callback:buildChain} );
			gui.addStepper("titleLength", 1, 10);
			gui.addButton("random title", {callback:randomTitle});
			gui.show();
			
			text = FontConsolas.createTextfied("building markov chain....", 16);
			text.x = (stage.stageWidth - text.width) >> 1;
			text.y = (stage.stageHeight - text.height) >> 1;
			addChild(text);
		}
		
		private function randomTitle():void 
		{
			text.text = randomWordsFromMarkovChain(chain, titleLength, true);
			text.x = (stage.stageWidth - text.width) >> 1;
			text.y = (stage.stageHeight - text.height) >> 1;
		}
		
		private function buildChain(e:Event = null):void 
		{
			removeEventListener(Event.ENTER_FRAME, buildChain);
			chain = markovChainFromTitles(loadLinesFromTextFile(TextFile), chainOrder);
			randomTitle();
		}
	}
}