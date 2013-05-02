package as3_user_interface_kit
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 座標値、幅、高さを表すクラスです.
	 * @author takanosatoshi
	 *
	 */
	public class Frame extends Rectangle
	{
		/**
		 * コンストラクタ.
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 *
		 */
		public function Frame(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super(x, y, width, height);
		}
		
		/**
		 * フレームのプロパティを設定します. 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * 
		 */		
		public function set(x:Number, y:Number, width:Number, height:Number):void
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		override public function clone():Rectangle
		{
			return new Frame(x, y, width, height);
		}
		
		public function get origin():Point
		{
			return topLeft;
		}
		
		public function set origin(pos:Point):void
		{
			//topLeft = pos;
			this.x = pos.x;
			this.y = pos.y;
		}
		
		/**
		 * 中心座標を表す<code>Point</code>インスタンス. 
		 * @return 
		 */		
		public function get center():Point
		{
			return new Point(x + width / 2, y + height / 2);
		}
		
		public function set center(center:Point):void
		{
			x = center.x - width / 2;
			y = center.y - height / 2;
		}
		
		public function get isZero():Boolean {
			return width == 0 && height == 0;
		}

	}
}