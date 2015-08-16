package net.avdw.animated.fx
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.avdw.layer.layerFromRadialGradient;
	import net.avdw.demo.ADemo;
	import net.avdw.math.Vector2D;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Lightning extends ADemo
	{
		
		public function Lightning()
		{
			addChild(layerFromRadialGradient(stage.stageWidth, stage.stageHeight));
			
			var bolt:LightningBolt = new LightningBolt(new Vector2D(stage.stageWidth * .2, stage.stageHeight * .5), new Vector2D(stage.stageWidth * .8, stage.stageHeight * .5));
			addChild(bolt);
		}
	}
}
import com.bit101.charts.LineChart;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Vector3D;
import net.avdw.interpolation.*;
import net.avdw.math.Vector2D;
import net.avdw.random.randomNumber;

class LightningBolt extends Sprite
{
	public const joints:Vector.<Vector2D> = new Vector.<Vector2D>();
	
	public function LightningBolt(start:Vector2D, end:Vector2D, thickness:Number = 3, numJoints:int = 0)
	{
		var i:int;
		var lightningVector:Vector2D = end.clone().subtract(start);
		
		if (numJoints == 0)
			numJoints = lightningVector.length() / 4;
		
		var intercepts:Array = [];
		for (i = 0; i < numJoints; i++)
			intercepts.push(Math.random());
		intercepts.sort();
		
		const displaceAngle:Number = Math.PI * .25;
		const jaggedness:Number = 1 / (lightningVector.length() * Math.tan(displaceAngle));
		
		joints.push(start);
		var displacement:Number = 0;
		for (i = 1; i < intercepts.length; i++)
		{
			/// need to reduce displacement near end
			/// need to branch
			var interceptDelta:Number = (intercepts[i] - intercepts[i - 1]) * lightningVector.length();
			displacement += randomNumber( -interceptDelta * Math.tan(displaceAngle), interceptDelta * Math.tan(displaceAngle));
			
			displacement *= intercepts[i] > .9 ? .75 : 1;
			
			joints.push(start.clone().lerp(intercepts[i], end).add(lightningVector.normalLeft.length(displacement)));
		}
		joints.push(end);
		
		filters = [new GlowFilter()];
		render();
	}
	
	private function render():void
	{
		if (joints.length == 0)
			return;
			
		graphics.lineStyle(3, 0xFFFFFF, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND, 3);
		graphics.moveTo(joints[0].x, joints[0].y);
		for each (var joint:Vector2D in joints)
		{
			graphics.lineTo(joint.x, joint.y);
		}
	}
}

class BranchLightning
{

}

class LightningShape
{

}

class GrowingLightningBolt
{

}