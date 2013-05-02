package as3_animation_kit.interpolator
{
	import as3_animation_kit.IEasing
	public class Liner
	{
		private static var _ease:IEasing;
		public function Liner()
		{
		}
		
		public static function ease():IEasing
		{
			if (_ease == null)
				_ease = new Ease();
			return _ease;
		}
		
	}
}
import as3_animation_kit.IEasing

internal class Ease implements IEasing
{
	public function calculate(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * t / d + b;
	}
}