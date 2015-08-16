package net.avdw.demo.fx
{
	import com.bit101.components.Label;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import net.avdw.background.bgFromCode;
	import net.avdw.demo.ADemo;
	import net.avdw.number.round;
	import net.avdw.random.randomBit;
	import net.avdw.random.randomSign;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CoinSpinDemo extends ADemo
	{
		private var throwsLabel:Label;
		private var headsLabel:Label;
		private var tailsLabel:Label;
		private var gui:SimpleGUI;
		private var coins:Array = [];
		
		public var headToTailBias:Number = .2;
		
		public function CoinSpinDemo()
		{
			var coin:Coin;
			[Embed(source="CoinSpinDemo.as",mimeType="application/octet-stream")]
			const TextFile:Class;
			addChild(bgFromCode(stage.stageWidth, stage.stageHeight,TextFile));
			
			var numCoins:int = ((stage.stageWidth / 128) +1) * ((stage.stageHeight / 128) +1);
			
			for (var i:int = 0; i < numCoins; i++) {
				coin = new Coin();
				coin.addEventListener(MouseEvent.CLICK, spinCoin);
				coins.push(coin);
				addChild(coin);
			}
			
			var x:int = 0, y:int = 0;
			for each (coin in coins) {
				coin.heads(biasCoin(headToTailBias) == 1);
				coin.x = x;
				coin.y = y;
				x += 128 + 10;
				if (x > stage.stageWidth + 128) {
					x = 0;
					y += 128 + 10;
				}
			}
			
			gui = new SimpleGUI(this, "biased coin");
			gui.addSlider("headToTailBias", 0.01, .99);
			gui.addButton("spin", { callback:spin } );
			gui.addLabel("bias coin average (10,000 throws)");
			headsLabel = gui.addLabel("\theads");
			tailsLabel = gui.addLabel("\ttails");
			gui.addLabel("average throws to remove bias");
			throwsLabel = gui.addLabel("\tthrows");
			gui.addLabel("removing bias is done by");
			gui.addLabel("taking the first coin");
			gui.addLabel("of two biased coin throws,");
			gui.addLabel("that are not the same"); 
			gui.show();
			
			spin();
		}
		
		private function spin():void 
		{
			for each (var coin:Coin in coins) {
				coin.heads(biasCoin(headToTailBias) == 1);
				coin.spin(6 + randomBit() * randomSign() * 2);
			}
			
			var count:int = 0;
			for (var i:int = 0; i < 10000; i++)
				count += removeBiasFromBiasCoin(headToTailBias);
			
			throwsLabel.text = "\tTHROWS\t" + round((count / 10000), 1);
				
			var percentage:Number = distribution(biasCoin, headToTailBias);
			headsLabel.text = "\tHEADS\t" + round(percentage*100, 1) + "%";
			tailsLabel.text = "\tTAILS\t\t" + round((1 - percentage)*100, 1) + "%";
		}
		
		private function spinCoin(e:MouseEvent):void 
		{
			e.target.heads(biasCoin(headToTailBias) == 1);
			e.target.spin(4);
		}
		
		public function distribution(biasFunction:Function, bias:Number):Number
		{
			var count:int = 0;
			for (var i:int = 0; i < 10000; i++)
			{
				count += biasFunction.apply(this, [bias]);
			}
			return count / 10000;
		}
		
		public function biasCoin(bias:Number):int
		{
			return Math.random() < bias ? 1 : 0;
		}
		
		public function removeBiasFromBiasCoin(bias:Number):int
		{
			var rethrows:int = 0;
			var coin1:int, coin2:int;
			while ((coin1 = biasCoin(bias)) == (coin2 = biasCoin(bias)))
				rethrows += 2;
				
			// return coin1 to get a throw that is unbiased
			// will return [1 or 0] 50% of the time
			return rethrows; 
		}
	}

}

import com.greensock.easing.*;
import com.greensock.TweenLite;
import flash.display.Bitmap;
import flash.display.Sprite;
import net.avdw.interpolation.sineEaseIn;

class Coin extends Sprite
{
	[Embed(source="../../../../../../net.avdw.assets/images/coin-head.png")]
	private const headsClass:Class;
	[Embed(source="../../../../../../net.avdw.assets/images/coin-tail.png")]
	private const tailsClass:Class;
	
	private const headsBmp:Bitmap = new headsClass();
	private const tailsBmp:Bitmap = new tailsClass();
	
	private var spinCount:int;
	private var maxSpinCount:int;
	
	public function Coin()
	{
		Math.random() < .5 ? addChild(headsBmp) : addChild(tailsBmp);
		headsBmp.x = tailsBmp.x = -headsBmp.width / 2;
		headsBmp.y = tailsBmp.y = -headsBmp.height / 2;
		width = height = 128;
	}
	
	private function startSpin():void
	{
		if (spinCount > 0)
			TweenLite.to(this, .2 * (1 - spinCount / maxSpinCount), {width: 0, onComplete: halfwaySpin, ease: Sine.easeIn});
	}
	
	private function halfwaySpin():void
	{
		swap();
		spinCount--;
		TweenLite.to(this, .2 * (1 - spinCount / maxSpinCount), {width: 128 - 32 * sineEaseIn(spinCount / maxSpinCount), onComplete: startSpin, ease: Sine.easeOut});
	}
	
	public function spin(count:int = 8):void
	{
		spinCount = maxSpinCount = count;
		startSpin();
	}
	
	public function swap():void
	{
		contains(headsBmp) ? tails() : heads();
	}
	
	public function tails(isTails:Boolean = true):void
	{
		if (!isTails) 
			heads();
		else if (contains(headsBmp))
		{
			removeChild(headsBmp);
			addChild(tailsBmp);
		}
	}
	
	public function heads(isHeads:Boolean = true):void
	{
		if (!isHeads)
			tails();
		else if (contains(tailsBmp))
		{
			removeChild(tailsBmp);
			addChild(headsBmp);
		}
	}

}