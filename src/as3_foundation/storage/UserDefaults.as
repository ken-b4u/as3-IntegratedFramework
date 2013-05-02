package as3_foundation.storage
{
	import flash.net.SharedObject;

	public class UserDefaults
	{
		public static const NAME:String = "config";
		private var _obj:Object = {};
		private static var _instance:UserDefaults;
		public var fileEncoding:String = "UTF-8";
		private var _so:SharedObject;

		/**
		 * @private
		 * @param si
		 *
		 */
		public function UserDefaults(si:SingletonEnforcer)
		{
			_so = SharedObject.getLocal(NAME);
			var data:Object = _so.data;
			for (var key:String in data)
			{
				_obj[key] = data[key];
			}
		}

		/**
		 * <code>UserDefaults</code>の唯一のインスタンスを返します.
		 * @return
		 *
		 */
		public static function instance():UserDefaults
		{
			if (_instance == null)
				_instance = new UserDefaults(new SingletonEnforcer());
			return _instance;
		}

		/**
		 * ユーザーのローカル記憶領域にデータを永続化します.
		 *
		 */
		public function syncronize():void
		{
			var data:Object = _so.data;
			for (var key:String in _obj)
			{
				data[key] = _obj[key];
			}
			_so.flush();
		}
		
		/**
		 * 永続化されているデータをリセットします. 
		 * 
		 */		
		public function reset():void
		{
			_so.clear();
		}

		/**
		 * 永続化するための文字列をセットします.
		 * @param value
		 * @param key
		 *
		 */
		public function setStringForKey(value:String, key:String):void
		{
			_obj[key] = value;
		}

		/**
		 * キー値から永続化されている文字列を取得します.
		 * @param key
		 * @return
		 *
		 */
		public function stringForKey(key:String):String
		{
			return _obj[key];
		}

	}
}

internal class SingletonEnforcer
{
}