package net.avdw.generated.draw
{
	import flash.display.Graphics;
	import net.avdw.math.MathConstant;
	import net.avdw.math.Point2D;
	
	/**
	 * Draws an arc between two angles
	 * @param	graphics		graphics object to use
	 * @param	pointCenter 	center point of the arc
	 * @param	angleFrom		starting angle in radians
	 * @param	angleTo			ending angle in radians
	 * @param	radius			distance from the center point
	 * @param	anticlockwise	direction to draw in, only affects fills
	 */
	public function drawArc(graphics:Graphics, pointCenter:Point2D, angleFrom:Number, angleTo:Number, radius:Number, fill:Boolean = false, anticlockwise:Boolean = false):void
	{
		if (angleFrom > angleTo)
			angleFrom -= MathConstant.TWO_PI;
		
		var angleDelta:Number = angleTo - angleFrom;
		var angleIncr:Number = .1 * MathConstant.DEG_2_RAD / angleDelta;
		var penPoint:Point2D;
		var angleCurr:Number;
		
		if (anticlockwise)
		{
			penPoint = pointCenter.clone().offsetPolar(radius, angleTo);
			if (!fill)
				graphics.moveTo(penPoint.x, penPoint.y);
			for (angleCurr = angleTo; angleCurr >= angleFrom; angleCurr -= angleIncr)
			{
				penPoint = pointCenter.clone().offsetPolar(radius, angleCurr);
				graphics.lineTo(penPoint.x, penPoint.y);
			}
		}
		else
		{
			penPoint = pointCenter.clone().offsetPolar(radius, angleFrom);
			if (!fill)
				graphics.moveTo(penPoint.x, penPoint.y);
			for (angleCurr = angleFrom; angleCurr <= angleTo; angleCurr += angleIncr)
			{
				penPoint = pointCenter.clone().offsetPolar(radius, angleCurr);
				graphics.lineTo(penPoint.x, penPoint.y);
			}
		}
	}
}