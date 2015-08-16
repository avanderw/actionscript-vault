/**
 * Copyright sazzzzz ( http://wonderfl.net/user/sazzzzz )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/tcGz
 */

// forked from sazzzzz's forked from: ビリビリ（Lightning Effect）
// forked from mousepancyo's ビリビリ（Lightning Effect）
/*
比較的簡単に実装できそうな方法で
稲妻というか放電風のビリビリを作ってみました。

マウスクリックでビリビリの出現点が変化します。
*/

package net.avdw.fx {    
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    
    [SWF(width="465", height="465", backgroundColor="0", frameRate="30")]
    
    public class Lightning01 extends Sprite{
        private const W:Number = 465;
        private const H:Number = 465;
        private const RANGE:int = 31; // 1,3,5,15,31,93,155,465
        private var _p:Point;
        private var _sp:Sprite;
        private var _ctf:ColorTransform;
        private var _canvas:BitmapData;
        private var _glow:BitmapData;
        
        private var _rad:Number = 0.0;

        public function Lightning01() {
            //This is all the initialization you need in your main class
            inittrace(stage);
            
            init();
            addEventListener(Event.ENTER_FRAME, update)    ;
            stage.addEventListener(MouseEvent.CLICK, onDown);
        }
        
        private function log(msg:String):void{
            ExternalInterface.call("console.log", msg);
        }

        
        private function init():void{
            _p = new Point(W / 2, H - 30);
            _sp = new Sprite();
            _sp.filters = [new GlowFilter(0xC9E6FC, 1, 10, 10, 4, 3, false, false)];
            _ctf = new ColorTransform(0.9, 0.96, 1, 0.9);
            _canvas = new BitmapData(W,H,false,0);
            
            var bm:Bitmap = new Bitmap(_canvas, "auto", true);
            _glow = new BitmapData(W / RANGE, H / RANGE, false, 0);
            
            var glowBm:Bitmap = new Bitmap(_glow, "never", true);
            glowBm.blendMode = "add";
            glowBm.scaleX = RANGE;
            glowBm.scaleY = RANGE;
            
            addChild(bm);
            addChild(glowBm);
        }
        
        private function onDown(e:MouseEvent):void{
            _p = new Point(mouseX, mouseY);
        }
                
        private function update(e:Event):void{
            var p:Point = new Point();
            var num:int = Math.random() * 5;
            p.x = _p.x;
            p.y = _p.y;
            _sp.graphics.clear();
            _sp.graphics.lineStyle(num, 0xFFFFFF, 1-(num / 10));
            _sp.graphics.moveTo(p.x, p.y);
            
            var m:Point = new Point(mouseX, mouseY);
            _rad += Math.random() * 90.0 * Math.PI / 180.0 * (Math.random() * 2.0 - 1.0);
            var rad:Number = _rad;
            var speed:int = Math.random() * 10;
            
            var v:Point = new Point();
            v.x = Math.cos(rad) * speed;
            v.y = Math.sin(rad) * speed;
            
            var vo:Point = new Point();
            var vs:Point = new Point();
            var vr:Point = new Point();
            var vl:Point = new Point();
            var rel:Point = new Point();
            var max:Number = 60.0;
            var maxrad:Number = Math.PI / 180 * max;
            var doo:Number;
            var d:Number = 999.0;
            var noise:int;
            
            while( d >= 1 ){
                speed = Math.random() * 10;
                
                //元のベクトル
                doo = Math.sqrt(v.x * v.x + v.y * v.y);
                if(doo > 0){
                    vo.x = v.x / doo * speed;
                    vo.y = v.y / doo * speed;
                }else{
                    vo.x = 0;
                    vo.y = speed;
                }
                
                // 書き始め位置から、書き終わり位置への相対位置ベクトル
                rel.x = m.x - p.x;
                rel.y = m.y - p.y;
                
                // straight
                d = Math.sqrt(rel.x * rel.x + rel.y * rel.y);
                if(d > 0){
                    vs.x = rel.x / d * speed;
                    vs.y = rel.y / d * speed;
                }else{
                    vs.x = 0;
                    vs.y = speed;
                }
                
                // clockwise
                
                if(d < 1){
                    // goal
                    v.x = rel.x;
                    v.y = rel.y;
                }else{
                    // continue
                    
                    // 速度ベクトルvoを回転
                    vr.x = Math.cos(maxrad) * vo.x - Math.sin(maxrad) * vo.y;
                    vr.y = Math.sin(maxrad) * vo.x + Math.cos(maxrad) * vo.y;
                    vl.x = Math.cos(-maxrad) * vo.x - Math.sin(-maxrad) * vo.y;
                    vl.y = Math.sin(-maxrad) * vo.x + Math.cos(-maxrad) * vo.y;
                   
                    if(vo.x * vs.x + vo.y * vs.y <= vo.x * vr.x + vo.y * vr.y){
                        // in range
                        v.x = vs.x;
                        v.y = vs.y;
                    }else{
                        // out of range
                        
                        // clockwise or counterclock
                        if(rel.x * vr.x + rel.y * vr.y <= rel.x * vl.x + rel.y * vl.y){
                            // clock
                            v.x = vr.x;
                            v.y = vr.y;
                        }else{
                            // counter
                            v.x = vl.x;
                            v.y = vl.y;
                        }
                    }
                   //noise = Math.random() * 8 - 4;
                    //v.x += noise;
                    //v.y += noise;
                }

                p.x += v.x;
                p.y += v.y;
                _sp.graphics.lineTo(p.x, p.y);
            }
            
            _canvas.colorTransform(_canvas.rect, _ctf);
            _canvas.draw(_sp);
            _glow.draw(_canvas, new Matrix(1 / RANGE, 0, 0, 1 / RANGE));
        }
    }
}

/////  WONDERFL TRACE /////

import flash.display.Sprite;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFormat;


function inittrace(s:Stage):void
{
    WTrace.initTrace(s);
}

//global trace function
var trace:Function;

//wtreace class
class WTrace
{
    private static var FONT:String = "Fixedsys";
    private static var SIZE:Number = 12;
    private static var TextFields:Array = [];
    private static var trace_stage:Stage;
    
    public static function initTrace(stg:Stage):void
    {
        trace_stage = stg;
        trace = wtrace;
    }
    
    private static function scrollup():void
    {
        // maximum number of lines: 100
        if (TextFields.length > 100) 
        {
            var removeme:TextField = TextFields.shift();
            trace_stage.removeChild(removeme);
            removeme = null;
        }
        for(var x:Number=0;x<TextFields.length;x++)
        {
            (TextFields[x] as TextField).y -= SIZE*1.2;
        }
    }

    public static function wtrace(... args):void
    {
    
        var s:String="";
        var tracefield:TextField;
        
        for (var i:int;i < args.length;i++)
        {
            // imitating flash:
            // putting a space between the parameters
            if (i != 0) s+=" ";
            s+=args[i].toString();
        }
        

        tracefield= new TextField();
        tracefield.autoSize = "left";
        tracefield.text = s;
        tracefield.y = trace_stage.stageHeight - 20;
        tracefield.textColor = 0x999999;

        var tf:TextFormat = new TextFormat(FONT, SIZE);
        tracefield.setTextFormat(tf);
        trace_stage.addChild(tracefield);
        scrollup();                      
        TextFields.push(tracefield);
        
    }
}





