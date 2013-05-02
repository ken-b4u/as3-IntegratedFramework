package as3_animation_kit
{

	/**
	 * <code>NumericalInterpolator</code>クラスは、与えられた "開始値" と "目的値" を補間します.
	 */
	public class NumericalInterpolator
	{
		private var _targetValue:Number;
		private var _startValue:Number;
		private var _valueArray:Array;
		private var _currentFrame:Number = 0;
		private var _numSteps:Number;

		// メソッド呼び出しのオーバーヘッドを極力除くために property として宣言.
		// 不正な値を代入されても next() をコールする度に正しい値が再設定されるので、
		// 悪意がない限りバグは発生しないと。（願望
		public var isEnd:Boolean = false;

		/**
		 * コンストラクタ.
		 * @param targetValue 目的値
		 * @param currentValue 開始値
		 * @param numSteps 何ステップで補間するか
		 * @param easing イージング関数
		 *
		 */
		function NumericalInterpolator(targetValue:Number, currentValue:Number, numSteps:int, easing:IEasing)
		{
			_targetValue = targetValue;
			_startValue = currentValue;
			_numSteps = numSteps;

			_valueArray = new Array();

			var t:Number = 0;
			var c:Number = _targetValue - _startValue;

			while (t++ < _numSteps)
			{
				var v:Number = easing.calculate(t, _startValue, c, _numSteps);
				_valueArray.push(v);
			}
		}

		/**
		 * 補間したデータが入っている<code>Vector</code>を返します.
		 * @return
		 *
		 */
		public function getData():Array
		{
			return _valueArray.slice(0, _valueArray.length);
		}

		/**
		 * 次フレームの移動先となる値を返し、内部的な値のポインタをひとつ進めます.
		 * @return
		 *
		 */
		public function next():Number
		{
			var val:Number = _valueArray[_currentFrame++ % _numSteps];
			isEnd = _currentFrame >= _numSteps;
			return val;
		}

		/**
		 * 前フレームの移動先となる値を返し、内部的な値のポインタをひとつ戻します.
		 * @return
		 *
		 */
		public function prev():Number
		{
			var val:Number = _valueArray[--_currentFrame];
			isEnd = _currentFrame <= 0;
			return val;
		}

		/**
		 * 開始値です.
		 * @return
		 *
		 */
		public function get startValue():Number
		{
			return _startValue;
		}

		/**
		 * 目的値です.
		 * @return
		 *
		 */
		public function get targetValue():Number
		{
			return _targetValue;
		}
		
		public function get progress():Number {
			return _currentFrame / _numSteps;			
		}
		
		public function reset():void {
			_currentFrame = 0;
		}
		
	}
}
