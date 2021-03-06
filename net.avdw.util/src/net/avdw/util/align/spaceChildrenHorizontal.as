package net.avdw.align
{
	import flash.display.DisplayObjectContainer;
	
	public function spaceChildrenHorizontal(containers:Array, ... spacingValues):void
	{
		for each (var container:DisplayObjectContainer in containers)
		{
			var children:Array = [];
			for (var i:int = 0; i < container.numChildren; i++)
				children.push(container.getChildAt(i));
			
			var args:Array = [children];
			args = args.concat(spacingValues);
			
			spaceHorizontal.apply(null, args);
		}
	}
}