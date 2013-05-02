package as3_foundation
{

	/**
	 * 通知オブジェクト.
	 * @author takanosatoshi
	 */
	public class Notification
	{
		private var _object:*;
		private var _name:String;

		/**
		 * コンストラクタ.
		 * @param name 通知名
		 * @param object 通知を受け取る側に渡すオブジェクト
		 *
		 */
		public function Notification(name:String, object:Object = null)
		{
			_name = name;
			_object = object;
		}

		/**
		 * 引き回し用のオブジェクト.
		 * @return
		 *
		 */
		public function get object():*
		{
			return _object;
		}
		
		public function set object(o:*):void {
			_object = o;
		}

		/**
		 * 通知名.
		 * @return
		 *
		 */
		public function get name():String
		{
			return _name;
		}
	}
}
