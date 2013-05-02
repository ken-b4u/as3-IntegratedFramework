package as3_foundation
{
	public class Performer
	{
		private var _target:Object;
		private var _function:Function;
		private var _args:Object;
		
		/**
		 * <code>Performer</code>インスタンスの作成.
		 * <p>
		 * 	関数オブジェクトと、その関数が定義されたクラスのインスタンス、また引数として渡すオブジェクトをバインドします。
		 * </p>
		 * @param target 関数が定義されたクラスのインスタンス
		 * @param func 関数オブジェクト
		 * @param args 引数として渡すオブジェクト
		 * 
		 */		
		public function Performer(target:Object, func:Function, ...args)
		{
			_target = target;
			_function = func;
			_args = args;
		}
	
		/**
		 * バインドされている関数を評価します. 
		 * 
		 */		
		public function perform():void
		{
			_function.apply(_target, _args);
		}
	}
}