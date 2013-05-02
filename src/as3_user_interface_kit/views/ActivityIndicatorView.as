package as3_user_interface_kit.views
{
	import flash.display.CapsStyle;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	public class ActivityIndicatorView extends View
	{
		public function ActivityIndicatorView()
		{
			super();
			this.filters = [new DropShadowFilter(1, 90, 0, 0.5, 2, 2)];
		}
		
		public function get useDropshadow():Boolean
		{
			return (this.filters && this.filters.length);
		}
		
		public function set useDropshadow(value:Boolean):void
		{
			if (value) this.filters = [new DropShadowFilter(1, 90, 0, 0.5, 2, 2)];
			else this.filters = [];
		}
		
		public function start():void{
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		public function stop():void{
			removeEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		private var cnt:int = 0;
		private function enterFrameListener(e:Event):void{
			if(cnt > 2){
				rotation += 360/numNeedles;
				cnt = 0;
			} else  cnt++;
		}
		public var numNeedles:int = 12;
		public var startColor:uint = 0xffffff;
		public var endColor:uint = 0Xcccccc;
		override protected function draw():void
		{
			super.draw();
			
			var _radius:int = frame.width/2;
			var _barLength:int = _radius / 1.9;
			var thickness:Number = _radius / numNeedles * 2.1;
			x += _radius;
			y += _radius;
			
			var color:uint = startColor;
			var differenceBig:Number;
			var differenceMiddle:Number;
			var differenceMin:Number;
			
			//開始色と終了職のRGBごとの値を取得
			var sb:Number = startColor % 256;
			var sg:Number = (startColor >> 8) % 256;
			var sr:Number = (startColor >> 16) % 256;
			var eb:Number = endColor % 256;
			var eg:Number = (endColor >> 8) % 256;
			var er:Number = (endColor >> 16) % 256;
			
			//開始色と終了色の差をRGBごとに計算
			differenceBig = int((er - sr) / numNeedles) * 256 * 256;
			differenceMiddle = int((eg - sg) / numNeedles) * 256;
			differenceMin = int((eb - sb) / numNeedles);
			
			//現在の表示の消去
			graphics.clear();
			
			//円形にバーを描画する処理
			for(var i:Number = 0; i<=numNeedles; i++){
				var angle:Number = -(i * 360 / numNeedles) - 90;
				
				var sin:Number = Math.sin(angle * Math.PI / 180);
				var cos:Number = Math.cos(angle * Math.PI / 180);
				
				//バーの開始点と終了点を計算
				var point1:Point = new Point(cos * _radius, sin * _radius);
				var point2:Point = new Point(cos * (_radius - _barLength), sin * (_radius - _barLength));
				
				//バーの描画
				graphics.lineStyle(thickness, color, 1, false, null, CapsStyle.ROUND);
				graphics.moveTo(point1.x, point1.y);
				graphics.lineTo(point2.x, point2.y);
				
				//色を１段階終了色に近づける
				color += differenceBig;
				color += differenceMiddle;
				color += differenceMin;
			}
		}
			
	}
}