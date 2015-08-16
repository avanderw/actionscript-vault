package
{
	import avdw.math.vector2d.Vector2D;
	import com.nodename.Delaunay.Voronoi;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.avdw.graphics.drawVoronoiRegion;
	import net.avdw.graphics.fillVoronoiRegion;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class SmallworldGraphExpansionDemo extends Sprite
	{
		private var voronoi:Voronoi;
		private var races:Vector.<Race> = new Vector.<Race>();
		private var territories:Vector.<Territory>;
		
		public function SmallworldGraphExpansionDemo()
		{
			if (stage)
				start();
			else
				addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, start);
			addEventListener(Event.ENTER_FRAME, setup);
			
			var gui:SimpleGUI = new SimpleGUI(this);
			gui.addButton("clear races", {callback: clearRaces});
			gui.addButton("add race", {callback: addRace});
			gui.addButton("play turn", {callback: playTurn});
			gui.show();
		}
		
		private function playTurn():void
		{
			for each (var race:Race in races)
			{
				// retrieve free tokens	
				for each (var territory:Territory in race.territories)
					while (territory.tokens > 1)
					{
						race.freeTokens++;
						territory.tokens--;
					}
				
				while (race.freeTokens > 2)
				{
					// decide on territory to invade
					if (race.territories.length == 0)
						var invadeTerritory:Territory = territories[Math.floor(Math.random() * territories.length)];
					else
					{
						var rndTerritory:Territory = race.territories[Math.floor(Math.random() * race.territories.length)];
						invadeTerritory = rndTerritory.neighbours[Math.floor(Math.random() * rndTerritory.neighbours.length)];
					}
					
					// invade free territory (fix to do 1 + things on terrain)
					if (invadeTerritory.owner == null || invadeTerritory.owner != race)
					{
						var tokenExchange:int = 1;
						if (invadeTerritory.owner == null)
							tokenExchange++;
						else
						{
							// if attacking player, give tokens back
							tokenExchange += invadeTerritory.tokens;
							invadeTerritory.owner.freeTokens += invadeTerritory.tokens - 1; // fix to ruleset
							invadeTerritory.tokens = 0;
							invadeTerritory.owner.territories.splice(invadeTerritory.owner.territories.indexOf(invadeTerritory), 1);
						}
						
						// take territory
						race.freeTokens -= tokenExchange;
						invadeTerritory.tokens += tokenExchange;
						race.territories.push(invadeTerritory);
						invadeTerritory.owner = race;
					}
				}
			}
			
			updateRender();
		}
		
		private function clearRaces():void
		{
			races.splice(0, races.length);
			updateRender();
		}
		
		private function addRace():void
		{
			races.push(new Race());
		}
		
		private function setup(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, setup);
			
			territories = new Vector.<Territory>();
			var points:Vector.<Point> = new Vector.<Point>();
			var colors:Vector.<uint> = new Vector.<uint>();
			var plotBounds:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			for (var i:int = 0; i < 30; i++)
			{
				points.push(new Point(int(Math.random() * stage.stageWidth), int(Math.random() * stage.stageHeight)));
				colors.push(0);
				
				var territory:Territory = new Territory();
				territory.coord = points[points.length - 1];
				territories.push(territory);
			}
			
			// create graph
			voronoi = new Voronoi(points, colors, plotBounds);
			voronoi.regions(); // bug if not called before neighbourSitesForSite
			for each (territory in territories)
			{
				var neighbourCoords:Vector.<Point> = voronoi.neighborSitesForSite(territory.coord);
				for each (var neighbourCoord:Point in neighbourCoords)
				{
					for each (var linkTerritory:Territory in territories)
						if (linkTerritory.coord == neighbourCoord)
						{
							territory.neighbours.push(linkTerritory);
							break;
						}
				}
			}
			
			updateRender();
		}
		
		private function updateRender():void
		{
			graphics.clear();
			renderRaces();
			renderBorders();
		}
		
		private function renderRaces():void
		{
			for each (var race:Race in races)
				for each (var territory:Territory in race.territories)
				{
					fillVoronoiRegion(voronoi.region(territory.coord), race.debugColor, graphics);
					for (var i:int = 0; i < territory.tokens; i++)
					{
						graphics.beginFill(0);
						graphics.drawRect(territory.coord.x + 1 + i * 5, territory.coord.y, 5, 5);
						graphics.endFill();
					}
				}
		}
		
		private function renderBorders():void
		{
			graphics.lineStyle(2);
			var regions:Vector.<Vector.<Point>> = voronoi.regions();
			for each (var region:Vector.<Point>in regions)
				drawVoronoiRegion(region, graphics);
		
		}
	
	}
}

import flash.geom.Point;

class Race
{
	public var debugColor:uint = 0;
	public var freeTokens:int = 11;
	public var territories:Vector.<Territory> = new Vector.<Territory>();
	
	public function Race()
	{
		debugColor = 0xFF000000 | Math.random() * 0xFFFFFF;
	}
}

class Territory
{
	public var coord:Point;
	public var tokens:int = 0;
	public var neighbours:Vector.<Territory> = new Vector.<Territory>();
	public var owner:Race;

}