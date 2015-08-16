package net.avdw.align
{
	public function alignVerticalBottomHorizontalRight(objectsToPosition:Array, withinObject:Object = null):void
	{
		alignHorizontalRightTo(objectsToPosition, withinObject);
		alignVerticalBottom(objectsToPosition, withinObject);
	}
}