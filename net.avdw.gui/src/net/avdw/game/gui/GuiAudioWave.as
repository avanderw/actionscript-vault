package net.avdw.game.gui
{
	import com.greensock.loading.data.VideoLoaderVars;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GuiAudioWave extends Sprite
	{
		private const container:Sprite = new Sprite();
		[Embed(source="../../../../../audio/03.Avicii - Wake Me Up (Extended Mix).mp3")]
		private const EmbeddedSound:Class;
		
		public function GuiAudioWave(width:int = 200, height:int = 150)
		{
			container.graphics.beginFill(0);
			container.graphics.drawRect(0, 0, width, height);
			container.graphics.endFill();
			addChild(container);
			
			const sound:Sound = new EmbeddedSound();
			sound.play();
			
			addEventListener(Event.ENTER_FRAME, animate);
		}
		
		private const particles:Vector.<Particle> = new Vector.<Particle>;
		
		public function init():void {
			for (var count:int = 0; count < CHANNEL_LENGTH; count++) {
				particles.push(new Particle());
			}
		}
		
		private function animate(e:Event):void
		{
			const PLOT_HEIGHT:int = 200;
			const CHANNEL_LENGTH:int = 256;
			
			const bytes:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum(bytes, false, 2);
			var g:Graphics = this.graphics;
			
			g.clear();
			g.lineStyle(0, 0x6600CC);
			g.beginFill(0x6600CC);
			g.moveTo(0, PLOT_HEIGHT);
			
			var n:Number = 0;
			
			// left channel 
			for (var i:int = 0; i < CHANNEL_LENGTH; i++)
			{
				n = (bytes.readFloat() * PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
			}
			g.lineTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			g.endFill();
			
			// right channel 
			g.lineStyle(0, 0xCC0066);
			g.beginFill(0xCC0066, 0.5);
			g.moveTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			
			for (i = CHANNEL_LENGTH; i > 0; i--)
			{
				n = (bytes.readFloat() * PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
			}
			g.lineTo(0, PLOT_HEIGHT);
			g.endFill();
		}
	
	}

}

class Particle
{
	public var x:Number = 0;
	public var y:Number = 0;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var ax:Number = 0;
	public var ay:Number = 0;
	public var friction:Number = 1;
	
	public function update():void {
		vx += ax;
		vx *= friction;
		x += vx;
		
		vy += ay;
		vy *= friction;
		y += vy;
	}
}