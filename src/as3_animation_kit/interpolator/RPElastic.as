package as3_animation_kit.interpolator
{
	import as3_animation_kit.IEasing;

	/**
	 * Robert Penner Elastic イージング関数.
	 * @see http://www.robertpenner.com/
	 * @author tkn
	 *
	 */
	public class RPElastic
	{
		private static var _easeIn:IEasing;
		private static var _easeOut:IEasing;
		private static var _easeInOut:IEasing;

		/**
		 * easeIn 関数を返します.
		 * @return
		 *
		 */
		public static function easeIn():IEasing
		{
			if (_easeIn == null)
				_easeIn = new EaseIn();
			return _easeIn;
		}

		/**
		 * easeOut 関数を返します.
		 * @return
		 *
		 */
		public static function easeOut():IEasing
		{
			if (_easeOut == null)
				_easeOut = new EaseOut();
			return _easeOut;
		}

		/**
		 * easeInOut 関数を返します.
		 * @return
		 *
		 */
		public static function easeInOut():IEasing
		{
			if (_easeInOut == null)
				_easeInOut = new EaseInOut();
			return _easeInOut;
		}
	}
}

import as3_animation_kit.IEasing;


internal class EaseIn implements IEasing
{
	/**
	 * @inheritDoc
	 */
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number, p:Number;
		if (t == 0)
			return b;
		if ((t /= d) == 1)
			return b + c;
		if (!p)
			p = d * .3;
		if (!a || a < Math.abs(c))
		{
			a = c;
			var s:Number = p / 4;
		}
		else
			var s:Number = p / (2 * Math.PI) * Math.asin(c / a);
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
	}
}

internal class EaseOut implements IEasing
{
	/**
	 * @inheritDoc
	 */
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number, p:Number;
		if (t == 0)
			return b;
		if ((t /= d) == 1)
			return b + c;
		if (!p)
			p = d * .3;
		if (!a || a < Math.abs(c))
		{
			a = c;
			var s:Number = p / 4;
		}
		else
			var s:Number = p / (2 * Math.PI) * Math.asin(c / a);
		return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b);
	}
}

internal class EaseInOut implements IEasing
{
	/**
	 * @inheritDoc
	 */
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number, p:Number;
		if (t == 0)
			return b;
		if ((t /= d / 2) == 2)
			return b + c;
		if (!p)
			p = d * (.3 * 1.5);
		if (!a || a < Math.abs(c))
		{
			a = c;
			var s:Number = p / 4;
		}
		else
			var s:Number = p / (2 * Math.PI) * Math.asin(c / a);
		if (t < 1)
			return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
	}
}