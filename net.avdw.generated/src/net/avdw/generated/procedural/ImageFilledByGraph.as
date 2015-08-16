package
{
	import com.nodename.Delaunay.Voronoi;
	import com.nodename.geom.LineSegment;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.utils.Timer;
	import net.avdw.algorithm.createUrquhartGraph;
	import net.avdw.number.SeededRNG;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ImageFilledByGraph extends Sprite
	{
		
		[Embed(source="../../../assets/images/Dancing_Girls_Silhouettes_Set_Preview3.jpg")]
		private const ImageClass:Class;
		[Embed(source="../../../assets/images/256x256 Monster.png")]
		private const OtherImageClass:Class;
		
		private var data:Vector.<Point>;
		private var colors:Vector.<uint>;
		private var bmp:Bitmap;
		private var type:String;
		private var timer:Timer;
		private var gui:SimpleGUI;
		private var loading:TextField;
		
		public var fill:Number = .05;
		public const state:Object = {image1: false, urquhart: false, delaunay: true, spanning: false, type: "delaunay"};
		
		public function ImageFilledByGraph()
		{
			loading = new TextField();
			loading.text = "DRAWING ...";
			//debug();
			timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, draw);
			
			gui = new SimpleGUI(this);
			gui.addSlider("fill", .01, .2, {callback: delayBuild});
			gui.addToggle("state.spanning", {callback: spanning, label:"Spanning tree (slow)"});
			gui.addToggle("state.delaunay", {callback: delaunay, label:"Delaunay"});
			gui.addToggle("state.urquhart", {callback: urgquhart, label:"Urquhart"});
			gui.addToggle("state.image1", {callback: delayBuild, label:"Switch image"});
			gui.show();
			
			build();
			draw();
		}
		
		private function build():void
		{
			bmp = (state.image1) ? new OtherImageClass() : new ImageClass();
			var x:int, y:int;
			data = new Vector.<Point>();
			colors = new Vector.<uint>();
			for (y = 0; y < bmp.bitmapData.height; y++)
			{
				for (x = 0; x < bmp.bitmapData.width; x++)
				{
					if ((bmp.bitmapData.getPixel(x, y) != 0xFFFFFF && (bmp.bitmapData.getPixel32(x, y) >> 24) != 0) && SeededRNG.boolean(fill))
					{
						data.push(new Point(x, y));
						colors.push(0);
					}
				}
			}
			loading.x = -this.x;
			loading.y = -this.y;
			addChild(loading);
		}
		
		private function delayBuild():void
		{
			timer.reset();
			build();
			timer.start();
		}
		
		private function urgquhart():void
		{
			state.type = "urquhart";
			state.urquhart = true;
			state.spanning = false;
			state.delaunay = false;
			delayBuild();
		}
		
		private function delaunay():void
		{
			state.type = "delaunay";
			state.urquhart = false;
			state.spanning = false;
			state.delaunay = true;
			delayBuild();
		}
		
		private function spanning():void
		{
			state.type = "spanning";
			state.urquhart = false;
			state.spanning = true;
			state.delaunay = false;
			delayBuild();
		}
		
		public function draw(e:TimerEvent = null):void
		{
			graphics.clear();
			graphics.lineStyle(1);
			var voronoi:Voronoi = new Voronoi(data, colors, bmp.bitmapData.rect);
			var lines:Vector.<LineSegment>;
			switch (state.type)
			{
				case "spanning": 
					lines = voronoi.spanningTree();
					break;
				case "delaunay": 
					lines = voronoi.delaunayTriangulation();
					break;
				case "urquhart": 
					lines = createUrquhartGraph(voronoi);
					break;
				default: 
					lines = new Vector.<LineSegment>();
			}
			for each (var line:LineSegment in lines)
			{
				graphics.moveTo(line.p0.x, line.p0.y);
				graphics.lineTo(line.p1.x, line.p1.y);
			}
			this.x = (stage.stageWidth - bmp.bitmapData.width) / 2;
			this.y = (stage.stageHeight - bmp.bitmapData.height) / 2;
			gui.hide();
			
			if (contains(loading)) {
				removeChild(loading);
			}
		}
		
		public function debug():void
		{
			bmp.bitmapData.fillRect(bmp.bitmapData.rect, 0xFFFFFFFF);
			for each (var point:Point in data)
			{
				bmp.bitmapData.setPixel(point.x, point.y, 0);
			}
			addChild(bmp);
		}
	}

}