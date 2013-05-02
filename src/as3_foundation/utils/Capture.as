package as3_foundation.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 表示オブジェクトを BitmapData に転写するユーティリティクラス.　
	 */
	public class Capture
	{
		public function Capture()
		{
		}

		/**
		 * 表示オブジェクトをBitmapDataに転写して返します.
		 * @param target
		 * @return
		 *
		 */
		public static function getBitmapData(target:DisplayObject, matrix:Matrix = null, clipRect:Rectangle = null, smooth:Boolean = false):BitmapData
		{
			var bmd:BitmapData = new BitmapData(target.width + 1, target.height + 1, true, 0);
			bmd.draw(target, matrix, null, null, clipRect, smooth);
			return bmd;
		}

		/**
		 * 引数に渡されたBitmapDataの透明な余白部分を取り除いて返します.
		 * @param bmd
		 * @return
		 *
		 */
		public static function sizeToFit(bmd:BitmapData):BitmapData
		{
			var x:int = bmd.width;
			var y:int = bmd.height;
			var width:int = 0;
			var height:int = 0;
			for (var w:int = 0; w < bmd.width; w++)
			{
				for (var h:int = 0; h < bmd.height; h++)
				{
					var col:uint = bmd.getPixel(w, h);
					if (col)
					{
						x = Math.min(x, w);
						// 最も左にある有色ピクセル座標
						width = Math.max(width, w);
						// 最も右にある有色ピクセル座標
						y = Math.min(y, h);
						// 最も上にある有色ピクセル座標
						height = Math.max(height, h);
							// 最も下にある有色ピクセル座標
					}
				}
			}
			if (width == 0 || height == 0)
				return bmd;

			var clip:Rectangle = new Rectangle(x, y, width, height);
			var newBmd:BitmapData = new BitmapData(width - x, height - y, true, 0);
			newBmd.copyPixels(bmd, clip, new Point());
			bmd.dispose();
			return newBmd;
		}
	}
}