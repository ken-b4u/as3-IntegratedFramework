package as3_foundation.net
{
	/**
	 * URLを表現するクラスです。 via <a href="http://wonderfl.net/c/z0QE">http://wonderfl.net/c/z0QE</a> 
	 * @author tkn
	 * 
	 */	
	public class URL
	{
		private static const _fields:Object = {
			"scheme": 2,
			"host": 6,
			"port": 7,
			"user": 4,
			"pass": 5,
			"path": 8,
			"query": 9,
			"fragment": 10
		};
		private static const _regex:RegExp = /^((\w+):\/\/)?((\w+):?(\w+)?@)?([^\/\?:]+):?(\d+)?(\/?[^\?#]+)?\??([^#]+)?#?([^#]*)/;
		
		/**
		 * URLスキーマ. 
		 */		
		public var scheme:String;
		
		/**
		 * ホスト. 
		 */		
		public var host:String;
		/**
		 * ポート.
		 */		
		public var port:String;
		/**
		 * ユーザー.
		 */		
		public var user:String;
		/**
		 * パスワード.
		 */		
		public var pass:String;
		/**
		 * パス.
		 */		
		public var path:String;
		/**
		 * URLパラメータ. 
		 */		
		public var query:String;
		/**
		 * フラグメント. 
		 */		
		public var fragment:String;
		
		public function get url():String { return _getURL(); }
		public function set url(u:String):void { _parse(u); }
		
		public function URL(_url:String = "")
		{
			url = _url;
			_init();
			_parse(_url);
		}
		
		public function toString():String
		{
			var str:String = "";
			str += "scheme   : " + scheme + "\n";
			str += "host     : " + host + "\n";
			str += "port     : " + port + "\n";
			str += "user     : " + user + "\n";
			str += "pass     : " + pass + "\n";
			str += "path     : " + path + "\n";
			str += "qury     : " + query + "\n";
			str += "fragment : " + fragment + "\n";
			return str;
		}
		
		private function _init():void
		{
			scheme = "";
			host = "";
			port = "";
			user = "";
			pass = "";
			path = "";
			query = "";
			fragment = "";
		}
		
		private function _parse(url:String):void
		{
			_init();
			
			if (url) {
				var r:Array = _regex.exec(url);
				if (r) {
					var value:String = "";
					for (var f:String in _fields) {
						value = r[_fields[f]];
						if (value) {
							this[f] = value;
						}
					}
				}
			}
		}
		
		private function _getURL():String
		{
			var s:String = "";
			if (scheme) {
				s += scheme + "://";
			}
			if (user) {
				s += user;
			}
			if (pass) {
				s += ":" + pass;
			}
			if (user || pass) {
				s += "@";
			}
			s += host;
			if (port) {
				s += ":" + port;
			}
			s += path;
			if (query) {
				s += "?" + query;
			}
			if (fragment) {
				s += "#" + fragment;
			}
			return s;
		}
		
	}
}