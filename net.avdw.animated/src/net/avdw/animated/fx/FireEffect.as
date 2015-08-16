/**
 * Copyright o_healer ( http://wonderfl.net/user/o_healer )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/dzI0
 */

/*
　炎の表現用テストコード

　概要
　・ビットマップに値を描けば、あとは自動で炎として処理するようなコードの試作
　・マウスの位置を火元として描く
　　・クリックしながら移動した部分はそのまま残る
　・ついでに木目の実験も兼ねる

　炎のアルゴリズム
　・基本的な考え方は http://wonderfl.net/c/rolo/ のものを採用
　・処理のおおまかな流れとしては以下のような感じ
　　・「発火元」を描く
　　・パーリンノイズで減衰させて、揺らぎながら消えるようにする
　　・炎を上にスクロールする
*/

package net.avdw.fx {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.media.*;
 
    [SWF(width="465", height="465", frameRate="30", backgroundColor="0x000000")]
    public class FireEffect extends Sprite {

        //==Const==

        //表示サイズ
        static public const VIEW_W:int = 465;
        static public const VIEW_H:int = 465;

        //Utility
        static public const VIEW_RECT:Rectangle = new Rectangle(0,0,VIEW_W,VIEW_H);
        static public const POS_ZERO:Point = new Point(0,0);


        //==Var==

        //#炎の描画＆処理まわり

        //実際の表示に使うビットマップ
        public var m_BitmapData_View:BitmapData = new BitmapData(VIEW_W, VIEW_H, true, 0x00000000);
        //炎の状態を0x00～0xFFで保持するデータ
        public var m_BitmapData_Fire:BitmapData = new BitmapData(VIEW_W, VIEW_H, false, 0x00);
        //Fire => Viewの変換のためのパレット（0x00～0xFFの値を、実際の炎の色に置き換える）
        public var m_Palette_Fire_to_View:Array = new Array(256);
        //減衰に使うためのパーリンノイズ
        public var m_BitmapData_PerlinNoise:BitmapData = new BitmapData(VIEW_W * 2, VIEW_H * 2, false, 0x000000);
        //スクロールに使うマトリクス
        public var m_Mtx_PerlinNoise:Matrix = new Matrix();
        //広げるためのブラーフィルター
        public var m_Filter_FireBlur:BlurFilter = new BlurFilter(4,4);

        //#発火部分の描画まわり

        static public const LINE_W:uint = 16;
        public var mouseX_Old:int = 0;
        public var mouseY_Old:int = 0;
        public var fireShape:Shape = new Shape();
        public var fireShape_Fix:Shape = new Shape();

        //#背景
        public var m_BitmapData_BG:BitmapData = new BitmapData(VIEW_W, VIEW_H, false, 0x000000);


        //==Function==

        //Init
        public function FireEffect(){
            var i:int;

            //m_BitmapData_PerlinNoise
            {
                //普通にパーリンノイズを生成して
                const PanelLen:int = 24;//火種のおおまかな大きさ（ドット絵に使うので、１マス＝32ドットあたりを想定）
                const Octave:int = 2;//変化は雑でいい
                m_BitmapData_PerlinNoise.perlinNoise(PanelLen,PanelLen, Octave, 1000*Math.random(), true, true);
                //それを縦に２枚並べる形にして（スクロールするため。つなぎ目は気にしない）
                m_BitmapData_PerlinNoise.copyPixels(m_BitmapData_PerlinNoise, new Rectangle(0,0,VIEW_W*2,VIEW_H), new Point(0,VIEW_H));
                //減衰に使うため値を抑制
                const ratio:Number = 0.09;//小さくすると炎の伸びが大きくなる
                m_BitmapData_PerlinNoise.colorTransform(
                    m_BitmapData_PerlinNoise.rect,//VIEW_RECTとは範囲が違うので、直のrectを使う
                    new ColorTransform(ratio,ratio,ratio)//値を減衰させる
                );
            }

            //m_Palette_Fire_to_View
            {
                for(i = 0; i < 256; i++){
                    //Cosによって発火部分と消える部分の境界を薄める
                    //さらにPowによって減衰の速さを調整する（白→黄色→橙になるように）
                    var r:uint = 0xFF * (0.5 - 0.5*Math.cos(Math.PI * Math.pow(i/255, 1.0)));
                    var g:uint = 0xFF * (0.5 - 0.5*Math.cos(Math.PI * Math.pow(i/255, 1.5)));
                    var b:uint = 0xFF * (0.5 - 0.5*Math.cos(Math.PI * Math.pow(i/255, 3.0)));

                    m_Palette_Fire_to_View[i] = (0xFF<<24)|(r<<16)|(g<<8)|(b<<0);
                }
            }

            //背景
            {
                //まずはパーリンノイズを生成
                {
                    const Base_W:int = VIEW_W*2;//大きいほど変化がゆるやかになる
                    const Base_H:int = VIEW_H/4;//大きいほど変化がゆるやかになる
                    const NumOctaves:int = 2;//きめ細かさ
                    m_BitmapData_BG.perlinNoise(Base_W,Base_H, NumOctaves, 1000*Math.random(), true, true, BitmapDataChannel.RED);
                }

                //それを木目っぽく変換
                {
                    //二つの色を周期的に配置して縞々にする
                    const SrcColor:uint = 0x281000;
                    const DstColor:uint = 0x8B4513;

                    //0x00～0xFFを何分割して色を周期的に配置するか
                    const Cycle:int = 16;

                    //Lerp
                    const Lerp:Function = function(in_Src:Number, in_Dst:Number, in_Ratio:Number):Number{
                        return (in_Src * (1 - in_Ratio)) + (in_Dst * in_Ratio);
                    };
                    const LerpColor:Function = function(in_Src:uint, in_Dst:uint, in_Ratio:Number):uint{
                        var r:uint = Lerp((in_Src>>16)&0xFF, (in_Dst>>16)&0xFF, in_Ratio);
                        var g:uint = Lerp((in_Src>>8)&0xFF,  (in_Dst>>8)&0xFF,  in_Ratio);
                        var b:uint = Lerp((in_Src>>0)&0xFF,  (in_Dst>>0)&0xFF,  in_Ratio);
                        return (0xFF<<24) | (r<<16) | (g<<8) | (b<<0);
                    };

                    //実際のパレット計算
                    var ColorPalette:Array = new Array(256);
                    for(i = 0; i < 256; i++){
                        var color_ratio:Number = i/255.0;
                        color_ratio = 0.5 - 0.5*Math.cos(Cycle * Math.PI * color_ratio);//周期的なRatio変化にする
                        color_ratio = 0.5 - 0.5*Math.cos(Math.PI * color_ratio);//0or1に値を寄せる
                        ColorPalette[i] = LerpColor(SrcColor, DstColor, color_ratio);
                    }

                    //適用
                    m_BitmapData_BG.paletteMap(m_BitmapData_BG, VIEW_RECT, POS_ZERO, ColorPalette);
                }

                //描画登録
                {
                    addChild(new Bitmap(m_BitmapData_BG));
                }
            }

            //炎の表示
            {
                var bmp_view:Bitmap = new Bitmap(m_BitmapData_View);
                bmp_view.blendMode = BlendMode.ADD;//加算表現にすることによって、黒＝透明として扱える
                addChild(bmp_view);
            }

            //マウスによる発火処理
            {
                addEventListener(
                    Event.ADDED_TO_STAGE,//stageに触るので、stageに登録されたあとに設定
                    function(e:Event):void{
                        stage.addEventListener(MouseEvent.MOUSE_MOVE,    DrawEmit);
                    }
                );
            }

            //Update
            {
                addEventListener(Event.ENTER_FRAME, Update);
            }
        }

        //Update
        public function Update(e:Event=null):void{
            //var DeltaTime:Number = 1.0 / stage.frameRate;

            //発火部分の描画
            Emit();

            //炎表現
            DrawFire();
        }

        //Emit：マウスに応じて発火
        public function DrawEmit(e:MouseEvent):void{
            if(e.buttonDown){//クリックされてる間だけ、固定発火の描画を行う
                var g:Graphics = fireShape_Fix.graphics;

                //マウスの動きに応じて線
                {
                    g.lineStyle(LINE_W,0x0000FF,1.0);
                    g.moveTo(mouseX_Old, mouseY_Old);
                    g.lineTo(mouseX, mouseY);
                }
            }
        }
        public function Emit():void{
            var g:Graphics = fireShape.graphics;

            //マウス位置に円
            {
                const RAD:uint = 8;

                g.lineStyle(0,0,0);
                g.beginFill(0x0000FF, 1.0);
                g.drawCircle(mouseX, mouseY, RAD);
                g.endFill();
            }

            //マウスの動きに応じて線
            {
                g.lineStyle(LINE_W,0x0000FF,1.0);
                g.moveTo(mouseX_Old, mouseY_Old);
                g.lineTo(mouseX, mouseY);
            }

            //発火元として描画
            {
                m_BitmapData_Fire.draw(fireShape);
                m_BitmapData_Fire.draw(fireShape_Fix);
            }

            //次回用更新
            {
                //揮発タイプは毎回リセット
                fireShape.graphics.clear();

                mouseX_Old = mouseX;
                mouseY_Old = mouseY;
            }
        }

        //DrawFire：炎の自動描画
        public function DrawFire():void{
            //描画処理
            {
                //ブラーで炎を広げる
                {
                    //薄めることで、上の方を細くする効果も兼ねる
                    m_BitmapData_Fire.applyFilter(m_BitmapData_Fire, VIEW_RECT, POS_ZERO, m_Filter_FireBlur);
                }

                //全体的に沈静化
                {
                    //パーリンノイズで減衰することで揺らぎを表現
                    m_BitmapData_Fire.draw(m_BitmapData_PerlinNoise, m_Mtx_PerlinNoise, null, BlendMode.SUBTRACT);
                }

                //そして0x00～0xFFの値を炎の色に置き換えて表示
                {
                    m_BitmapData_View.paletteMap(m_BitmapData_Fire, VIEW_RECT, POS_ZERO, null,null,m_Palette_Fire_to_View);
                }
            }

            //次回用の更新
            {
                const ScrollVal:int = 2;

                //炎を上にスクロールさせて、燃え上がりを実現
                {
                    //切り捨てて良いスクロールなので、普通にscrollを呼ぶ
                    m_BitmapData_Fire.scroll(0, -ScrollVal);
                }

                //パーリンノイズの採用位置を変更
                {
                    //横方向には少しだけ振動させ、上下方向は炎の上昇と合わせることで、それっぽい揺らぎを作り出す
                    m_Mtx_PerlinNoise.tx += (Math.random() < 0.5)? 1: -1;//振動
                    m_Mtx_PerlinNoise.ty -= ScrollVal;//追随
                    //範囲チェック
                    if(m_Mtx_PerlinNoise.tx > 0){m_Mtx_PerlinNoise.tx -= 2;}//範囲外は押し戻す
                    if(m_Mtx_PerlinNoise.tx < -VIEW_W){m_Mtx_PerlinNoise.tx += 2;}
                    if(m_Mtx_PerlinNoise.ty < -VIEW_H){m_Mtx_PerlinNoise.ty += VIEW_H;}//下にワープ
                }
            }
        }
    }
}

