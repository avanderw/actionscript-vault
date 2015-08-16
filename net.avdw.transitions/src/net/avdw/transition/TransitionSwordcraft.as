package net.avdw.transition
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.automation.Configuration;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import net.avdw.math.random.randomInteger;
	
	/**
	 * TODO consider managing bitmap drawing myself
	 * cacheAsBitmap is BAD for rotation / scaling / alpha
	 * see http://www.bytearray.org/?p=290
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class TransitionSwordcraft
	{
		static private const BOTTOM:int = 0;
		static private const RIGHT:int = 1;
		static private const TOP:int = 2;
		static private const LEFT:int = 3;
		
		static public const LEFT_2_RIGHT:int = 4;
		static public const RIGHT_2_LEFT:int = 5;
		static public const TOP_2_BOTTOM:int = 6;
		static public const BOTTOM_2_TOP:int = 7;
		
		static private var allowInstantiation:Boolean = false;
		private var _from:DisplayObject;
		private var _to:DisplayObject;
		private var _fromCover:Shape;
		private var _toCover:Shape;
		private var _onComplete:Function;
		private var _direction:int = RIGHT_2_LEFT;
		private var _ease:Ease = Linear.ease;
		
		public function TransitionSwordcraft()
		{
			if (!allowInstantiation)
				throw new Error("TransitionSwordcraft.from(object).to(object).transition()");
		}
		
		static public function from(displayObject:DisplayObject):TransitionSwordcraft
		{
			allowInstantiation = true;
			const transition:TransitionSwordcraft = new TransitionSwordcraft();
			allowInstantiation = false;
			
			transition._from = displayObject;
			return transition;
		}
		
		public function to(displayObject:DisplayObject):TransitionSwordcraft
		{
			_to = displayObject;
			return this;
		}
		
		public function direction(value:int):TransitionSwordcraft
		{
			_direction = value;
			switch (_direction)
			{
				case LEFT_2_RIGHT: 
				case RIGHT_2_LEFT: 
				case TOP_2_BOTTOM: 
				case BOTTOM_2_TOP: 
					break;
				default: 
					throw new Error("Invalid direction, use TransitionSwordcraft.RIGHT_2_LEFT");
			}
			return this;
		}
		
		public function ease(ease:Ease):TransitionSwordcraft {
			_ease = ease;
			return this;
		}
		
		public function onComplete(func:Function):TransitionSwordcraft
		{
			_onComplete = func;
			return this;
		}
		
		public function transition():TransitionSwordcraft
		{
			var toX:int;
			var toY:int;
			switch (_direction)
			{
				case RIGHT_2_LEFT: 
					_fromCover = createCover(_from, RIGHT, true);
					_toCover = createCover(_to, LEFT, false);
					toX = _from.x - _fromCover.width;
					toY = _from.y;
					break;
				case LEFT_2_RIGHT: 
					_fromCover = createCover(_from, LEFT, true);
					_toCover = createCover(_to, RIGHT, false);
					toX = _from.x + _fromCover.width;
					toY = _from.y;
					break;
				case BOTTOM_2_TOP: 
					_fromCover = createCover(_from, BOTTOM, true);
					_toCover = createCover(_to, TOP, false);
					toX = _from.x;
					toY = _from.y - _fromCover.height;
					break;
				case TOP_2_BOTTOM: 
					_fromCover = createCover(_from, TOP, true);
					_toCover = createCover(_to, BOTTOM, false);
					toX = _from.x;
					toY = _from.y + _fromCover.height;
					break;
			}
			
			const origFromCacheAsBitmap:Boolean = _from.cacheAsBitmap;
			const origFromIndex:int = _from.parent.getChildIndex(_from);
			_from.cacheAsBitmap = true;
			_fromCover.cacheAsBitmap = true;
			
			_from.parent.addChild(_fromCover);
			_from.mask = _fromCover;
			TweenLite.to(_fromCover, 1, {x: toX, y: toY, ease:_ease, onComplete: function():void
				{
					_from.cacheAsBitmap = origFromCacheAsBitmap;
					_fromCover.cacheAsBitmap = false;
					
					const origToCacheAsBitmap:Boolean = _to.cacheAsBitmap;
					_to.cacheAsBitmap = true;
					_toCover.cacheAsBitmap = true;
					
					_from.parent.addChildAt(_to, origFromIndex);
					_from.parent.addChild(_toCover);
					_to.mask = _toCover;
					
					_from.parent.removeChild(_fromCover);
					_from.parent.removeChild(_from);
					_from.mask = null;
					_fromCover = null;
					
					TweenLite.to(_toCover, 1, {x: _to.x, y: _to.y, ease:_ease, onComplete: function():void
						{
							_to.cacheAsBitmap = origToCacheAsBitmap;
							_toCover.cacheAsBitmap = false;
							
							_to.parent.removeChild(_toCover);
							_to.mask = null;
							_toCover = null;
							
							if (_onComplete != null)
								_onComplete.call();
						}});
				}});
			
			return this;
		}
		
		private function createCover(displayObject:DisplayObject, direction:int, cover:Boolean):Shape
		{
			var h:int;
			var w:int;
			const shape:Shape = new Shape();
			shape.graphics.lineStyle(1);
			switch (direction)
			{
				case LEFT: 
					for (h = 0; h < displayObject.height; h++)
					{
						shape.graphics.moveTo(randomInteger(-displayObject.width * .25, 0), h);
						shape.graphics.lineTo(displayObject.width, h);
					}
					
					shape.x = displayObject.x + (cover ? 0 : shape.width);
					shape.y = displayObject.y;
					break;
				case RIGHT: 
					for (h = 0; h < displayObject.height; h++)
					{
						shape.graphics.moveTo(0, h);
						shape.graphics.lineTo(displayObject.width + randomInteger(0, displayObject.width * .25), h);
					}
					shape.x = displayObject.x - (cover ? 0 : shape.width);
					shape.y = displayObject.y;
					break;
				case TOP: 
					for (w = 0; w < displayObject.width; w++) {
						shape.graphics.moveTo(w, randomInteger(-displayObject.height*.25, 0));
						shape.graphics.lineTo(w, displayObject.height);
					}
					shape.x = displayObject.x;
					shape.y = displayObject.y + (cover ? 0 : shape.height);
					break;
				case BOTTOM: 
					for (w = 0; w < displayObject.width; w++) {
						shape.graphics.moveTo(w, 0);
						shape.graphics.lineTo(w, displayObject.height + randomInteger(0, displayObject.height * .25));
					}
					shape.x = displayObject.x;
					shape.y = displayObject.y - (cover ? 0 : shape.height);
					break;
			}
			return shape;
		}
	
	}

}