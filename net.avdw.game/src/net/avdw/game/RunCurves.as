package net.avdw.game 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import net.avdw.math.Vector2D;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class RunCurves extends Sprite
	{
		private var playerTrail:BitmapData;
		private var player:Bitmap;
		private var playerVelocity:Vector2D;
		private var playerRotationSpeed:Number = 3 * Math.PI / 180;
		private var playerSize:int = 5;
		
		public function RunCurves() 
		{
			addEventListener(Event.ENTER_FRAME, startup);
		}
		
		private function startup(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, startup);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawCircle(0, 0, playerSize);
			shape.graphics.endFill();
			
			player = new Bitmap(new BitmapData(shape.width, shape.height, true, 0));
			player.bitmapData.draw(shape, new Matrix(1, 0, 0, 1, playerSize, playerSize));
			player.x = stage.stageWidth >> 1;
			player.y = stage.stageHeight >> 1;
			addChild(player);
			
			playerTrail = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			addChild(new Bitmap(playerTrail));
			
			playerVelocity = new Vector2D(0, 2);
			playerVelocity.rotate(Math.random() * 2 * Math.PI);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, inputPlayer);
			addEventListener(Event.ENTER_FRAME, updatePlayer);
			//addEventListener(Event.ENTER_FRAME, collisionDetection);
			addEventListener(Event.ENTER_FRAME, stampPlayer);
		}
		
		private function collisionDetection(e:Event):void 
		{
			if (playerTrail.hitTest(new Point, 1, player, new Point(player.x, player.y), 1)) {
				trace("hit");
			}
		}
		
		private function inputPlayer(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT) {
				playerVelocity.rotate( -playerRotationSpeed);
			}
			
			if (e.keyCode == Keyboard.RIGHT) {
				playerVelocity.rotate(playerRotationSpeed);
			}
		}
		
		private function updatePlayer(e:Event):void 
		{
			player.x += playerVelocity.x;
			player.y += playerVelocity.y;
		}
		
		private function stampPlayer(e:Event):void 
		{
			playerTrail.draw(player, player.transform.matrix);
		}
		
	}

}