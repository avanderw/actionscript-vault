package
{
	import com.nodename.Delaunay.Voronoi;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.avdw.generate.proximityMap;
	import net.avdw.graphics.drawFastLine;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ProximityMapDemo extends Sprite
	{
		private var proximityMapBmp:Bitmap;
		private var voronoi:Voronoi;
		private var selectedRegionOverlay:Sprite = new Sprite();
		
		public function ProximityMapDemo()
		{
			
			parent.addEventListener(KeyboardEvent.KEY_DOWN, generate);
			parent.addEventListener(MouseEvent.MOUSE_DOWN, addProximityMap);
			parent.addEventListener(MouseEvent.MOUSE_UP, removeProximityMap);
			parent.addEventListener(MouseEvent.MOUSE_MOVE, colorRegion);
			
			addChild(selectedRegionOverlay);
			generate(null);
		}
		
		private function generate(e:KeyboardEvent):void
		{
			var region:Vector.<Point>;
			var i:int;
			
			var points:Vector.<Point> = new Vector.<Point>();
			var colors:Vector.<uint> = new Vector.<uint>();
			var plotBounds:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			for (i = 0; i < 64; i++)
			{
				points.push(new Point(Math.floor(Math.random() * stage.stageWidth), Math.floor(Math.random() * stage.stageHeight)));
				colors.push(Math.random() * 0xFFFFFFFF);
			}
			
			voronoi = new Voronoi(points, colors, plotBounds);
			
			var site:Point;
			var sites:Vector.<Point> = voronoi.siteCoords();
			var regions:Vector.<Vector.<Point>> = voronoi.regions();
			var idx:int = 0;
			for each (site in sites)
			{
				graphics.beginFill(voronoi.siteColors()[idx]);
				
				graphics.lineStyle(1);
				
				drawRegion(voronoi.region(site), graphics);
				
				graphics.endFill();
				
				idx++;
			}
			
			proximityMapBmp = new Bitmap(proximityMap(voronoi));
		
		}
		
		private function colorRegion(e:MouseEvent):void
		{
			var nearestSiteToMouse:Point = voronoi.nearestSitePoint(proximityMapBmp.bitmapData, Math.floor(mouseX), Math.floor(mouseY));
			
			var region:Vector.<Point> = voronoi.region(nearestSiteToMouse);
			
			selectedRegionOverlay.graphics.clear();
			selectedRegionOverlay.graphics.beginFill(0, .5);
			drawRegion(region, selectedRegionOverlay.graphics);
			selectedRegionOverlay.graphics.endFill();
		}
		
		private function removeProximityMap(e:MouseEvent):void
		{
			removeChild(proximityMapBmp);
		}
		
		private function addProximityMap(e:MouseEvent):void
		{
			addChild(proximityMapBmp);
		}
		
		private function drawRegion(region:Vector.<Point>, graphics:Graphics):void
		{
			if (region == null || region.length == 0)
				return;
			
			var drawCoords:Vector.<Number> = new Vector.<Number>();
			var drawCommands:Vector.<int> = new Vector.<int>();
			
			drawCoords.push(region[0].x, region[0].y);
			drawCommands.push(GraphicsPathCommand.MOVE_TO);
			for each (var point:Point in region)
			{
				drawCoords.push(point.x, point.y);
				drawCommands.push(GraphicsPathCommand.LINE_TO);
			}
			drawCoords.push(region[0].x, region[0].y);
			drawCommands.push(GraphicsPathCommand.LINE_TO);
			
			graphics.drawPath(drawCommands, drawCoords);
		}
	
	}

}