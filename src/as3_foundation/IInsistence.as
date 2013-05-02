package as3_foundation
{
	/**
	 * 自分のクラス名、クラスオブジェクトを返すインターフェースです。
	 * @author takanosatoshi
	 */
	public interface IInsistence
	{
		/**
		 * クラスオブジェクトです.
		 * @return
		 *
		 */
		function get classObject():Class;

		/**
		 * クラス名です.
		 * @return
		 *
		 */
		function get className():String;
	}
}
