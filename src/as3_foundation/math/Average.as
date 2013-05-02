package as3_foundation.math
{
	public class Average
	{
		private var _numerator:Number = 0;
		private var _denominator:int = 0;
		
		public function Average()
		{
		}
		
		public function addNumber(value:Number):void {
			_numerator += value;
			_denominator++;
		}
		
		public function getAverage():Number {
			return _numerator / _denominator;
		}
		
		public function toString():String {
			return (_numerator / _denominator).toString();
		}
	}
}