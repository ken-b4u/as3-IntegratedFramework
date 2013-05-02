package as3_animation_kit
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * <code>NumericalMagneticChain</code>クラスは、与えられた複数の値の差を常に保ちつつ、その値のうち、収束値に最も近い物を徐々にその値に収束させます.
	 *
	 *  <p>磁石に吸着するように見えるスライダー、回転ダイアルなどのUIに使用できます。</p>
	 */
	public class NumericalMagneticChain
	{
		private var numPoints:int = 0;
		private var points:Array;
		private var magnet:Number = 0;
		private var offset:Number = 0;

		/**
		 * コンストラクタ.
		 * @param magnet 収束値
		 * @param offset points の間隔
		 * @param points 値の配列
		 *
		 */
		public function NumericalMagneticChain(magnet:Number, offset:Number, points:Array = null)
		{
			this.magnet = magnet;
			this.offset = offset;
			if (points)
				this.points = points;
			else
				this.points = [];

			numPoints = this.points.length;
		}

		/**
		 * index から特定される一つの値を、 value の値まで変化させます.
		 * <p>他の値は、コンストラクタに渡された時の他の値との差を保ったまま操作対象の値に合わせ変化します。</p>
		 */
		/*
		public function movePointAt(index:int, value:Number):void {
		var l:int = points.length;
		points[ index ] = value;

		for ( var prev:int = 0; prev < index; prev++ ) {
		points[ prev ] = value - offset * ( index - prev );
		}

		var next:int = index + 1;
		do {
		if ( l != next ) {
		if ( next < numPoints )
		points[ next ] = value + offset * ( next - index );
		}
		} while ( next++ <= l - index );
		}*/
		/**
		 * 全ての値に value の値を加算します.
		 */
		public function movePoint(value:Number):void
		{
			var l:int = points.length;

			var ratioF:Number = Math.abs(points[0] - magnet) / offset;
			//trace(( points[ 0 ] - magnet ) / offset);
			if ((points[0] - magnet) / offset > 0)
				value *= 0.5 - ratioF;

			var ratioE:Number = Math.abs(points[numPoints - 1] - magnet) / offset;
			if ((points[numPoints - 1] - magnet) / offset < 0)
			{
				value *= 0.5 - ratioE;
			}

			for (var i:int = 0; i < l; i++)
			{
				points[i] += value;
			}
		}

		/**
		 *　引数に渡されたインデックス値に該当する値を返します.
		 * @param index
		 * @return
		 *
		 */
		public function getValueAt(index:int):Number
		{
			return points[index];
		}

		/**
		 * 値を追加します.
		 */
		public function addPoint(value:Number):void
		{
			points.push(value);
			numPoints++;
		}

		/**
		 * 管理されている値の数です.
		 */
		public function get length():int
		{
			return numPoints;
		}

		/**
		 * 徐々に収束値に収束させます.
		 * <p>通常は、クライアントから毎フレーム呼び出すことでアニメーションさせます。</p>
		 */
		public function decrease():void
		{
			var l:int = points.length;
			for (var i:int = 0; i < l; i++)
			{
				var ratio:Number = Math.abs(points[i] - magnet) / offset;

				if (ratio < 0.5)
				{
					var index:int = i;
					var value:Number = points[index];

					var fraction:Number = Math.max(0.05, ratio);
					points[i] += (magnet - points[i]) * 0.2;

					for (var prev:int = 0; prev < index; prev++)
					{
						points[prev] = value - offset * (index - prev);
					}

					var next:int = index + 1;
					do
					{
						if (l != next)
						{
							if (next < numPoints)
								points[next] = value + offset * (next - index);
						}
					} while (next++ <= l - index);
				}
			}
		}
	}
}