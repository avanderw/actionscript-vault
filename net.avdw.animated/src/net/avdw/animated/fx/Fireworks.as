/**
 * Copyright mrgrotesque ( http://wonderfl.net/user/mrgrotesque )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/5899
 */

package net.avdw.fx
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    
    public class Fireworks extends Sprite
    {
        private var bitmap:Bitmap;
        private var buffer:BitmapData;
        private var black:Shape;

        public function Fireworks()
        {
            buffer = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );

            bitmap = new Bitmap( buffer );
            addChild( bitmap );
            
            black = new Shape();
            black.graphics.beginFill( 0, 0.05 );
            black.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight );
            black.graphics.endFill();
            
            addEventListener( Event.ENTER_FRAME, enterFrame );
            stage.addEventListener( MouseEvent.CLICK, click );
        }

        private function click(e:Event):void 
        {
            explosion(mouseX,mouseY);
        }
        
        private function enterFrame(e:Event):void 
        {
            for each( var v:Particle in Particle.list )
            {
                if ( v.waste ) continue;
                v.update();
                v.draw( buffer );
            }
            
            buffer.applyFilter( buffer, buffer.rect, new Point(), new BlurFilter(1.1, 1.1) );
            buffer.draw( black );
        }
        
        private function explosion( x:int, y:int ):void
        {
            var ct:ColorTransform = new ColorTransform();
            ct.color = 0xFFFFFF;
            
            switch( Math.floor( Math.random() * 3 ) )
            {
            case 0: ct.redOffset = Math.random()*128+128; break;
            case 1: ct.greenOffset = Math.random()*128+128; break;
            case 2: ct.blueOffset = Math.random()*128+128; break;
            }
            
            var i:int = 0;
            
            var shine:Shape = new Shape();
            shine.graphics.beginGradientFill( GradientType.RADIAL, [ ct.color, ct.color ], [ 0.5, 0 ], [ 0, 255 ] );
            shine.graphics.drawCircle( 0, 0, 96 );
            shine.graphics.endFill();
            buffer.draw( shine, new Matrix(1, 0, 0, 1, x, y) );
            
            for (i = 0; i <50 ; i++) 
            {
                var p:Particle = new FlickParticle();
                p.x = x;
                p.y = y;
                p.angle = Math.random() * 360;
                p.speed = Math.random() * 7;
                p.colorTransform.color = ct.color;
            }

            for (i = 0; i <400 ; i++) 
            {
                var par:Particle = new PixcelParticle();
                par.x = x;
                par.y = y;
                par.angle = Math.random() * 360;
                par.speed = Math.random() * 7;
                par.colorTransform.color = ct.color;
            }
        }
        
        public function kill():void
        {
            removeEventListener( Event.ENTER_FRAME, enterFrame );
            
            removeChild( bitmap );
            bitmap = null;

            buffer = null;
        }
    }
}
import flash.geom.ColorTransform;
import flash.display.BitmapData;
class Particle
{
    public static var list:Vector.<Particle> = new Vector.<Particle>();

    public var x:Number = 0;
    public var y:Number = 0;
    public var vx:Number = 0;
    public var vy:Number = 0;
    public var colorTransform:ColorTransform = new ColorTransform();
    public var waste:Boolean = false;
    public var gravity:Number = 0.5;
    public var friction:Number = 0.1;
    private var _speed:Number = 0;
    private var _angle:Number = 0;
    
    public var stageWidth:int = 800;
    public var stageHeight:int = 600;
    
    public function Particle() 
    {
        list.push( this );
    }
    
    public static function occasions():Particle
    {
        for each( var v:Particle in Particle.list )
        {
            if ( v.waste == true )
            {
                v.waste = false;
                return v;
            }
        }

        return new Particle();
    }
    
    public function draw( buffer:BitmapData ):void{}
    
    public function update():void
    {
        x += vx;
        y += vy;
        y += gravity;
        speed *= 1-friction;
        
        // 画面の外に出たらゴミ扱い
        if ( x < 0 || x > stageWidth || y < 0 || y > stageHeight ) waste = true;
    }
    
    public function set angle( value:Number ):void
    {
        _angle = value;
        vx = Math.cos(angle) * speed;
        vy = Math.sin(angle) * speed;
    }

    public function set speed( value:Number ):void
    {
        _speed = value;
        vx = Math.cos(angle) * speed;
        vy = Math.sin(angle) * speed;
    }
    
    public function get speed():Number { return _speed; }
    
    public function get angle():Number { return _angle; }
}

class PixcelParticle extends Particle
{
    private var disappearSpeed:int = 3;
    
    override public function draw(buffer:BitmapData):void 
    {
//            buffer.setPixel(x, y, color.value);
        var ct:ColorTransform = new ColorTransform();
        ct.color = buffer.getPixel(x, y);
        var r:int = ct.redOffset + colorTransform.redOffset;
        var g:int = ct.greenOffset + colorTransform.greenOffset;
        var b:int = ct.blueOffset + colorTransform.blueOffset;
        r = r > 255 ? 255 : r;
        g = g > 255 ? 255 : g;
        b = b > 255 ? 255 : b;
        ct = new ColorTransform( 1, 1, 1, 1, r, g, b);
        buffer.setPixel(x, y, ct.color);
    }
    
    override public function update():void 
    {
        super.update();
        
        var del:Boolean = true;
        if ( colorTransform.redOffset - disappearSpeed > 0 ) { colorTransform.redOffset -= disappearSpeed; del = false; }
        if ( colorTransform.greenOffset - disappearSpeed > 0 ) { colorTransform.greenOffset -= disappearSpeed; del = false; }
        if ( colorTransform.blueOffset - disappearSpeed > 0 ) { colorTransform.blueOffset -= disappearSpeed; del = false; }
        if ( del ) waste = true;
    }
}

class FlickParticle extends Particle
{
    override public function draw(buffer:BitmapData):void 
    {
        if ( Math.floor( Math.random() * 8) == 0 )
        {
            for (var i:int = -1; i <= 1; i++) 
            {
                for (var j:int = -1; j <= 1; j++) 
                {
                    buffer.setPixel(x+i, y+j, colorTransform.color);
                }
            }
        }
        
        // 適当に消す
        if ( Math.floor( Math.random() * 64) == 0 ) waste = true;
    }
}
