package net.avdw.align
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public function alignHorizontalCenterTo(within:Object, ...objectsToPosition):void
	{
		if (!objectsToPosition || objectsToPosition.length == 0)
			return;
		
		var tmpwithin:Object = within;
		for (var i:int = 0; i < objectsToPosition.length; i++)
		{
			if (!objectsToPosition[i] || !objectsToPosition[i].hasOwnProperty("width") || !objectsToPosition[i].hasOwnProperty("x"))
				continue;
			
			if (!within)
				if (objectsToPosition[i].parent)
					tmpwithin = objectsToPosition[i].parent;
				else
					continue;
			
			if (within is Stage)
				objectsToPosition[i].x = (within.stageWidth - objectsToPosition[i].width) / 2;
			else
				objectsToPosition[i].x = tmpwithin.x + (tmpwithin.width - objectsToPosition[i].width) / 2;
		}
	}
}
