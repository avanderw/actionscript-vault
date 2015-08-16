package net.avdw.align
{
	import flash.display.DisplayObject;
	
	public function alignCenterTo(within:Object, displayObject:DisplayObject):void
	{
		alignHorizontalCenterTo(within, displayObject);
		alignVerticalCenterTo(within, displayObject);
	}
}