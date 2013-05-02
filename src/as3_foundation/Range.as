package as3_foundation
{
	/**
	 * ある特定の数値の範囲を表現するクラス。 
	 * @author tkn
	 * 
	 */	
	public class Range
	{
		private var _min:Number;
		private var _max:Number;
		
		/**
		 * 最小値と最大値を渡して初期化します. 
		 * @param min
		 * @param max
		 * 
		 */		
		public function Range(min:Number, max:Number)
		{
			_min = min;
			_max = max;
		}
		
		/**
		 * 最小値. 
		 * @return 
		 * 
		 */		
		public function get min():Number
		{
			return _min;
		}
		
		/**
		 * 最大値. 
		 * @return 
		 * 
		 */		
		public function get max():Number
		{
			return _max;
		}
		
		public function remap(val:Number, range:Range):Number {
			return range.min + (range.length()) * this.ratio(val);
		}
		
		public function ratio(val:Number):Number {
			return (val - this.min) / this.length();
		}
		
		public function length():Number {
			return this.max - this.min;
		}
		
		public function contains(val:Number):Boolean {
			return (min <= val && val <= max);
		}
	}
}