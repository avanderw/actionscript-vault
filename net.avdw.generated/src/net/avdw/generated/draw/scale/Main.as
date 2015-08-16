package net.avdw.generated.draw.scale
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import net.avdw.font.EarlyGameBoyFont;
	import net.avdw.font.O4b30Font;
	import net.avdw.font.PfRondaSevenFont;
	import net.avdw.gui.SelectionBar;
	import net.avdw.text.embeddedFont;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	[SWF(width='640',height='832',frameRate='30',backgroundColor='#FFFFFF')]
	public class Main extends Sprite
	{
		[Embed(source="../../../../resource/image01.gif")]
		private const Image01Class:Class;
		[Embed(source="../../../../resource/image02.png")]
		private const Image02Class:Class;
		[Embed(source="../../../../resource/image03.gif")]
		private const Image03Class:Class;
		[Embed(source="../../../../resource/image04.gif")]
		private const Image04Class:Class;
		[Embed(source="../../../../resource/image05.gif")]
		private const Image05Class:Class;
		[Embed(source="../../../../resource/image06.png")]
		private const Image06Class:Class;
		[Embed(source="../../../../resource/image07.png")]
		private const Image07Class:Class;
		[Embed(source="../../../../resource/image08.png")]
		private const Image08Class:Class;
		[Embed(source="../../../../resource/image09.gif")]
		private const Image09Class:Class;
		[Embed(source="../../../../resource/image10.png")]
		private const Image10Class:Class;
		[Embed(source="../../../../resource/image11.png")]
		private const Image11Class:Class;
		[Embed(source="../../../../resource/image12.gif")]
		private const Image12Class:Class;
		
		private const image:Bitmap = new Bitmap();
		private const scale2x:Bitmap = new Bitmap();
		private const scale3x:Bitmap = new Bitmap();
		private const scale4x:Bitmap = new Bitmap();
		private const scale9x:Bitmap = new Bitmap();
		private const imageBitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>;
		
		private var idx:int;
		private const textfield:TextField= embeddedFont("Press any key...", PfRondaSevenFont.NAME, 16);
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			imageBitmapDatas.push((new Image01Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image02Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image03Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image04Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image05Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image06Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image07Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image08Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image09Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image10Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image11Class() as Bitmap).bitmapData);
			imageBitmapDatas.push((new Image12Class() as Bitmap).bitmapData);
			
			addChild(image);
			addChild(scale2x);
			addChild(scale3x);
			addChild(scale4x);
			addChild(scale9x);
			addChild(textfield);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, changeImage);
			
			changeImage();
		}
		
		private function changeImage(e:KeyboardEvent = null):void
		{
			image.bitmapData = imageBitmapDatas[idx];
			scale2x.bitmapData = ScaleX.scale2x(image.bitmapData);
			scale3x.bitmapData = ScaleX.scale3x(image.bitmapData);
			scale4x.bitmapData = ScaleX.scale2x(ScaleX.scale2x(image.bitmapData));
			scale9x.bitmapData = ScaleX.scale3x(ScaleX.scale3x(image.bitmapData));
			
			scale2x.x = image.x + image.width;
			scale3x.x = scale2x.x + scale2x.width;
			scale4x.x = scale3x.x + scale3x.width;
			scale9x.y = scale4x.y + scale4x.height;
			textfield.y = scale3x.y + scale3x.height;
			textfield.x = image.width;
			
			idx = ++idx % 12;
		}
	
	}

}