package as3_foundation.math
{
	public class MovingAverage extends Average
	{
		private var _length:int;
		private var _values:Vector.<Number>;
		
		public function MovingAverage(length:int)
		{
			_length = length;
			_values = new Vector.<Number>();
		}
		
		override public function addNumber(value:Number):void {
			_values.push(value);
			if (length < _values.length) _values.shift();
		}
		
		override public function getAverage():Number {
			var average:Number = 0;
			for (var i:int = 0; i < _length; i++) {
				average += _values[i];
			}
			return average / length;
		}
		
		override public function toString():String {
			return getAverage().toString();
		}
		
	}
}