package as3_user_interface_kit.views
{
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.geom.Matrix;
    
    public class FlexibleHeightImageView extends View
    {
        private var _top:Bitmap;
        private var _bottom:Bitmap;
        private var _center:Shape;
        private var _centerbmd:BitmapData;
        
        public function FlexibleHeightImageView(img:DisplayObject, topBottomHeight:Number)
        {
            var topbmd:BitmapData = new BitmapData(img.width, topBottomHeight, true, 0);
            topbmd.draw(img);
            _top = new Bitmap(topbmd);
            
            addChild(_top);
            
            var bottombmd:BitmapData = new BitmapData(img.width, topBottomHeight, true, 0);
            var m:Matrix = new Matrix();
            m.translate(0, -img.height + bottombmd.height);
            bottombmd.draw(img, m);
            _bottom = new Bitmap(bottombmd);
            
            addChild(_bottom);
            
            _centerbmd = new BitmapData(img.width, 1, true, 0);
            m = new Matrix();
            m.translate(0, -topBottomHeight);
            _centerbmd.draw(img, m);
            
            _center = new Shape();
            addChild(_center);
            _center.y = topBottomHeight;
        }
        
        override protected function draw():void {
            super.draw();
            
            height = Math.max(height, _top.height + _bottom.height);
            
            var g:Graphics = _center.graphics;
            g.clear();
            g.beginBitmapFill(_centerbmd);
            g.drawRect(0, 0, _top.width, height - _top.height - _bottom.height);
            g.endFill();
            _bottom.y = _center.y + _center.height - 1;
        }
    }
}