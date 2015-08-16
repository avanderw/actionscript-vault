package net.avdw.demo
{
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import net.avdw.debug.Debug;
	import net.avdw.decoration.wallpaper.*;
	import net.avdw.font.*;
	import net.avdw.gui.GuiList;
	import net.avdw.gui.GuiListItem;
	import net.avdw.gui.GuiPanel;
	import net.avdw.gui.GuiStyle;
	import net.avdw.transition.TransitionSwordcraft;
	
	[SWF(backgroundColor="0x0",frameRate="30",width="680",height="495")]
	public class DemoTransitionSwordcraft extends Sprite
	{
		[Embed(source="../../../../../net.avdw.resource/image/card-trading-01.png")]
		private const TradingCard1:Class;
		[Embed(source="../../../../../net.avdw.resource/image/card-trading-02.png")]
		private const TradingCard2:Class;
		[Embed(source="../../../../../net.avdw.resource/image/card-trading-03.png")]
		private const TradingCard3:Class;
		
		private const displayObject1:Bitmap = new TradingCard1();
		private const displayObject2:Bitmap = new TradingCard2();
		private const displayObject3:Bitmap = new TradingCard3();
		
		private const information:TextField = FontO4b03.createTextfied("Easing function used: ", 14);
		
		public function DemoTransitionSwordcraft():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Debug.decorate(stage);
			
			addChild(WallpaperMottled040.create(stage.stageWidth, stage.stageHeight));
			
			const panelStyle:GuiStyle = new GuiStyle;
			const panel:GuiPanel = new GuiPanel("Transition area!", panelStyle);
			panel.addDisplayObject(displayObject1);
			addChild(panel);
			
			panel.x = Math.round((stage.stageWidth - panel.width) >> 1);
			panel.y = Math.round((stage.stageHeight - panel.height) >> 1);
			
			displayObject1.x = displayObject2.x = displayObject3.x = Math.round(displayObject1.x);
			displayObject1.y = displayObject2.y = displayObject3.y = Math.round(displayObject1.y);
			
			transition();
			
			const controlList:GuiList = new GuiList(100);
			controlList.add(new GuiListItem(Cubic.easeIn, "Cubic"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Quint"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Circ"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Strong"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Sine"));
			controlList.add(new GuiListItem(Cubic.easeIn, "SlowMo"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Quad"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Expo"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Power4"));
			controlList.add(new GuiListItem(Cubic.easeIn, "Linear"));
			addChild(controlList);
			controlList.y = stage.stageHeight - controlList.height;
			
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
		}
		
		private function transition():void
		{
			if (!stage) 
				return;
			
			var from:DisplayObject;
			var to:DisplayObject;
			if (contains(displayObject1))
			{
				from = displayObject1;
				to = displayObject2;
			}
			else if (contains(displayObject2))
			{
				from = displayObject2;
				to = displayObject3;
			}
			else if (contains(displayObject3))
			{
				from = displayObject3;
				to = displayObject1;
			}
			
			var direction:int;
			const chance:Number = Math.random();
			if (chance < .25)
				direction = TransitionSwordcraft.LEFT_2_RIGHT;
			else if (chance < .5)
				direction = TransitionSwordcraft.RIGHT_2_LEFT;
			else if (chance < .75)
				direction = TransitionSwordcraft.TOP_2_BOTTOM;
			else
				direction = TransitionSwordcraft.BOTTOM_2_TOP;
			
			information.text = "Easing function used: ";
			var ease:Ease;
			if (chance < .1)
			{
				ease = Cubic.easeInOut;
				information.appendText("CUBIC");
			}
			else if (chance < .2)
			{
				ease = Quint.easeInOut;
				information.appendText("QUINT");
			}
			else if (chance < .3)
			{
				ease = Circ.easeInOut;
				information.appendText("CIRC");
			}
			else if (chance < .4)
			{
				ease = Strong.easeInOut;
				information.appendText("STRONG");
			}
			else if (chance < .5)
			{
				ease = Sine.easeInOut;
				information.appendText("SINE");
			}
			else if (chance < .6)
			{
				ease = SlowMo.ease;
				information.appendText("SLOWMO");
			}
			else if (chance < .7)
			{
				ease = Quad.easeInOut;
				information.appendText("QUAD");
			}
			else if (chance < .8)
			{
				ease = Expo.easeInOut;
				information.appendText("EXPO");
			}
			else if (chance < .9)
			{
				ease = Power4.easeInOut;
				information.appendText("POWER4");
			}
			else
			{
				ease = Linear.easeInOut;
				information.appendText("LINEAR");
			}
			
			information.appendText(".easeInOut");
			
			TransitionSwordcraft.from(from).to(to).direction(direction).ease(ease).transition().onComplete(transition);
		}
	
		private function this_removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStage);
			
		}
		
	}
}