package as3_foundation.net
{
	import flash.net.URLVariables;

	public class HTTPParameter
	{
		public function HTTPParameter()
		{
		}

		public static function getGetParameters(params:Object):String
		{
			var _params:String = "?";
			for (var key:String in params)
			{
				_params += key + "=" + params[key];
				_params += "&";
			}
			_params = _params.substr(0, _params.length - 1);
			return _params;
		}

		public static function getPostParameters(params:Object):URLVariables
		{
			var variables:URLVariables = new URLVariables();
			for (var key:String in params)
			{
				variables[key] = params[key];
			}
			return variables;
		}
	}
}