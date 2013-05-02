package as3_foundation.log
{
	
	
	public class NullOut implements IPrintable
	{
		private static var _instance:NullOut;
		
		public function NullOut(si:SingletonEnforcer)
		{
		}
		
		public function instance():NullOut
		{
			if (_instance == null) _instance = new NullOut(new SingletonEnforcer());
			return _instance;
		}
		
		public function print(characters:String):void
		{
			// 何もしない.
		}
	}
}

internal class SingletonEnforcer{}