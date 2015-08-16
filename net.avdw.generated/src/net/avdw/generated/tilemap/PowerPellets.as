package net.avdw.generated.tilemap
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import net.avdw.debug.tracepoint;
	import net.avdw.random.randomOffsetFrom;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class PowerPellets extends Sprite
	{
		public function PowerPellets(data:Array)
		{
			const spritesheet:Spritesheet = new Spritesheet(File.applicationDirectory.resolvePath("image/power-pellet-24x24.png"), 24, 24);
			spritesheet.whenLoaded.addOnce(function():void
				{
					spritesheet.sheetData.colorTransform(spritesheet.sheetData.rect, new ColorTransform(1, 1, 0, 1));
					for (var row:int = 0; row < data.length; row++)
						for (var col:int = 0; col < data[row].length; col++)
							switch (data[row][col])
						{
							case "*": 
								const powerPill:BitmapAnimation = spritesheet.createAnimation(0, 7);
								powerPill.playAfterDelay(randomOffsetFrom(1000, 100, 250), 6);
								powerPill.x = col * Board.TILE_WIDTH;
								powerPill.y = row * Board.TILE_HEIGHT;
								addChild(powerPill);
								break;
						}
				});
		
		}
	
	}

}