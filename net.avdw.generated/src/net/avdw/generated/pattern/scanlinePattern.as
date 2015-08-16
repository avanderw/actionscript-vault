package net.avdw.generated.pattern
{
	import flash.display.BitmapData;
	
	public function scanlinePattern(size:int = 3, thickness:int = 1, c:uint = 0xFF000000, horizontal:Boolean = true, both:Boolean = false):BitmapData
	{
		var row:int, col:int;
		const arr:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>;
		for (row = 0; row < size; row++)
		{
			const line:Vector.<uint> = new Vector.<uint>;
			for (col = 0; col < size; col++)
				line.push(0);
			arr.push(line);
		}
		
		if (horizontal || both)
			for (row = 0; row < thickness; row++)
				for (col = 0; col < size; col++)
					arr[row][col] = c;
		
		if (!horizontal || both)
			for (row = 0; row < size; row++)
				for (col = 0; col < thickness; col++)
					arr[row][col] = c;
		
		return makePattern(arr);
	}
}