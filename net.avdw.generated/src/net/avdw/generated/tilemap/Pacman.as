package net.avdw.generated.tilemap
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Pacman extends Sprite
	{
		private var upAnimation:BitmapAnimation;
		private var downAnimation:BitmapAnimation;
		private var leftAnimation:BitmapAnimation;
		private var rightAnimation:BitmapAnimation;
		public var botName:String;
		public var endScore:String;
		public const whenDoneMoving:Signal = new Signal;
		public var doneAnimating:Boolean = true;
		public var loaded:Boolean = false;
		
		public function Pacman(isPlayerA:Boolean)
		{
			const spritesheet:Spritesheet = new Spritesheet(File.applicationDirectory.resolvePath("image/pacman-24x24.png"), 24, 24);
			spritesheet.whenLoaded.addOnce(function():void
				{
					if (isPlayerA)
						spritesheet.tint(0xFF0000);
					else
						spritesheet.tint(0x00FF00);
					
					upAnimation = spritesheet.createAnimation(0, 4);
					downAnimation = spritesheet.createAnimation(1, 4);
					leftAnimation = spritesheet.createAnimation(2, 4);
					rightAnimation = spritesheet.createAnimation(3, 4);
					
					playAnimation(leftAnimation);
					loaded = true;
				});
		}
		
		private function playAnimation(animation:BitmapAnimation):void
		{
			removeChildren();
			
			addChild(animation);
			animation.play(8);
		}
		
		public function place(position:Point):void
		{
			x = position.x * Board.TILE_WIDTH;
			y = position.y * Board.TILE_HEIGHT;
		}
		
		public function move(position:Point):void
		{
			const newX:int = position.x * Board.TILE_WIDTH;
			const newY:int = position.y * Board.TILE_HEIGHT;
			
			if (newX < x)
				playAnimation(leftAnimation);
			else if (newX > x)
				playAnimation(rightAnimation);
			else if (newY < y)
				playAnimation(upAnimation);
			else if (newY > y)
				playAnimation(downAnimation);
			
			doneAnimating = false;
			TweenLite.to(this, .25, {x: newX, y: newY, onComplete: function():void
				{
					doneAnimating = true;
					whenDoneMoving.dispatch();
				}});
		
		}
	
	}

}