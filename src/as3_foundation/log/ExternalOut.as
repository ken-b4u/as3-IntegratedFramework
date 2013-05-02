package as3_foundation.log
{
	import flash.external.ExternalInterface;

	public class ExternalOut implements IPrintable
	{
		public static var _instance:ExternalOut;
		
		public function ExternalOut(sign:Sign)
		{
		}
		
		public static function instance():ExternalOut
		{
			if (_instance == null)
				_instance = new ExternalOut(new Sign());
			return _instance;
		}
		
		public function print(characters:String):void
		{
			trace(characters);
			if (ExternalInterface.available)
				ExternalInterface.call("console.log", characters);
		}
	}
}

internal class Sign{}