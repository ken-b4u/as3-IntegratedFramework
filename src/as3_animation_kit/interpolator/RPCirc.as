package as3_animation_kit.interpolator
{
	import as3_animation_kit.IEasing;
	
	/**
	 * Robert Penner Circ イージング関数.
	 * @see http://www.robertpenner.com/
	 * @author tkn
	 *
	 */
	public class RPCirc
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
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}
}

internal class EaseOut implements IEasing
{
	/**
	 * @inheritDoc
	 */	
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}
}

internal class EaseInOut implements IEasing
{
	/**
	 * @inheritDoc
	 */	
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}
}