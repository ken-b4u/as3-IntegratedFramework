package as3_animation_kit.interpolator
{
	import as3_animation_kit.IEasing;

	/**
	 * Robert Penner Bounce イージング関数.
	 * @see http://www.robertpenner.com/
	 * @author tkn
	 *
	 */
	public class RPBounce
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
		if ((t = (d - t) / d) < (1 / 2.75))
		{
			return c - (c * (7.5625 * t * t)) + b;
		}
		if (t < (2 / 2.75))
		{
			return c - (c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + b;
		}
		if (t < (2.5 / 2.75))
		{
			return c - (c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + b;
		}
		return c - (c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) + b;
	}
}

internal class EaseOut implements IEasing
{
	/**
	 * @inheritDoc
	 */
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		if ((t /= d) < (1 / 2.75))
		{
			return c * (7.5625 * t * t) + b;
		}
		else if (t < (2 / 2.75))
		{
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
		}
		else if (t < (2.5 / 2.75))
		{
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
		}
		else
		{
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
		}
	}
}

internal class EaseInOut implements IEasing
{
	/**
	 * @inheritDoc
	 */
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		var s:Number = 1.70158;
		if ((t /= d / 2) < 1)
			return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
	}
}