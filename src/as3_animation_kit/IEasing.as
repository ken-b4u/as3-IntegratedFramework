package as3_animation_kit
{
	/**
	 * イージング関数が実装する必要のあるインターフェースです.
	 * @author tkn
	 * 
	 */	
	public interface IEasing
	{
		/**
		 * 計算します. 
		 * @param t
		 * @param b
		 * @param c
		 * @param d
		 * @return 
		 * 
		 */		
		function calculate(t:Number, b:Number, c:Number, d:Number):Number;
	}
}