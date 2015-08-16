package net.avdw.align
{
	import flash.text.TextField;
	
	/**
	 * Will space a collection of items underneath the first element with or without spacing gaps.
	 * Note that this method has been written to make the code neater and more compact visually.
	 * It can be written more efficiently by moving the spacing-type check out of the inner loop.
	 * @param	items				items to be horizontally spaced
	 * @param	... spacingValues	the spacing to be used, either Number or Array
	 */
	public function spaceHorizontal(items:*, ... spacingValues):void
	{
		if (!items)
			return;
		
		var i:int;
		for (i = 1; i < items.length; i++)
		{
			if (!items[i] || !items[i - 1] || !items[i - 1].hasOwnProperty("width") || !items[i].hasOwnProperty("x"))
				continue;
			
			if (spacingValues.length > 0)
			{ // determine type of spacing
				if (spacingValues[0] is Array)
				{ // space horizontally using a spacing array
					items[i].x = int(items[(i - 1)].x + items[(i - 1)].width + spacingValues[0][i]);
				}
				else if (spacingValues[0] is Number)
				{ // space vertically using the same spacing value
					// space according to the objects height
					items[i].x = int(items[(i - 1)].x + items[(i - 1)].width + spacingValues[0]);
					
				}
			}
			else
			{ // space vertically with no space
				items[i].x = int(items[(i - 1)].x + items[(i - 1)].width);
			}
		}
	}
}