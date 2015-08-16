package net.avdw.geom
{
	import flash.geom.Point;
	
	public function pointInPoly(polygon:Vector.<Point>, x:Number, y:Number):Boolean
	{
		var i:int = 0;
		var j:int = polygon.length - 1;
		var c:Boolean = false;
		
		for (; i < polygon.length; j = i++)
			if (((polygon[i].y > y) != (polygon[j].y > y)) && (x < (polygon[j].x - polygon[i].x) * (y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x))
				c = !c;
		
		return c;
	}
}