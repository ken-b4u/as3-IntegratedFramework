package as3_foundation.log
{

	/**
	 * 標準出力クラス. 
	 * @author tkn
	 * 
	 */	
	public class StdOut implements IPrintable
	{
		private static var _instance:StdOut;
		
		/**
		 * @private 
		 * @param si
		 * 
		 */		
		public function StdOut(si:SingletonEnforcer)
		{
			
		}
		
		/**
		 * インスタンスを取得します. 
		 * @return 
		 * 
		 */		
		public static function instance():StdOut
		{
			if (_instance == null) _instance = new StdOut(new SingletonEnforcer());
			return _instance;
		}
		
		/**
		 * 開発環境の標準出力に出力します. 
		 * @param characters
		 * 
		 */		
		public function print(characters:String):void
		{
			trace(characters);
		}
	}
}

internal class SingletonEnforcer {}