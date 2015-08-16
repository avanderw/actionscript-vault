package net.avdw.align
{
	import flash.display.Stage;
	
	public function alignHorizontalRightTo(within:Object, ...objectsToPosition):void
	{
		if (!objectsToPosition || objectsToPosition.length == 0)
			return;
		
		for (var i:int = 0; i < objectsToPosition.length; i++)
		{
			if (!objectsToPosition[i] || !objectsToPosition[i].hasOwnProperty("width") || !objectsToPosition[i].hasOwnProperty("x"))
				continue;
			
			if (within is Stage)
				objectsToPosition[i].x = within.stageWidth - objectsToPosition[i].width;
			else
				objectsToPosition[i].x = within.x + within.width - objectsToPosition[i].width;
		}
	}
}