package as3_user_interface_kit.controllers
{
	import as3_foundation.Notification;
	import as3_foundation.NotificationCenter;
	
	import as3_user_interface_kit.models.ISceneProvider;
	import as3_user_interface_kit.models.SceneManager;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	/**
	 * <code>SWFAddress</code>を使用したシーンコントロールが可能なViewControllerです.
	 *
	 * <p><code>DeepLinkNavigationController</code>は、<code>NavigationController</code>の<code>pushViewController</code>,<code>popViewController</code>を override していて、
	 * そのなかでDeepLink解決に必要な処理を行っています。</p>
	 *
	 * <p><code>DeepLinkNavigationController</code>を使用する側のコードでは、DeepLinkに関しての実装を特に意識することなく、<code>NavigationController</code>を使用する感覚で、
	 * <code>pushViewController</code>,<code>popViewController</code>を使用するだけで、DeepLinkが実装できます。</p>
	 *
	 * <p>ひとつ制約があります。<code>DeepLinkNavigationController</code>に渡すコントローラは、<code>IDeepLinkableViewController</code>を実装している必要があるということです。
	 * 言語の仕様的には、<code>IDeepLinkableViewController</code>を実装していないクラスのインスタンスもメソッドの引数に渡せてしまいますが、そうした場合の挙動は保証されません。</p>
	 *
	 * TODO: DeepLink の階層構造設計
	 *
	 * @author tkn
	 * @see ui.models.SceneManager
	 * @see ui.controllers.IDeepLinkableViewController
	 *
	 */
	public class DeepLinkNavigationController extends NavigationController
	{
		private static var _rootViewController:ViewController;
		private static var _instance:DeepLinkNavigationController;

		private var _sceneManager:ISceneProvider;
		private var _indexViewController:IDeepLinkableViewController;
		private var _currentPath:String = "";

		/**
		 * コンストラクタ.
		 * @param index インデックスページのURLにアクセスされた場合に遷移する<code>IDeepLinkableViewController</code>インスタンス
		 *
		 */
		/**
		 *
		 * @param si
		 * @param root
		 */
		public function DeepLinkNavigationController(si:SingletonEnforcer, root:ViewController)
		{
			super(root);
			sceneManager;
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, swfAddressChangeListener);
			NotificationCenter.instance().addObserver(this, "SWFAddressChange", function():void
			{
				_currentPath = SWFAddress.getValue()
			});
		}

		public static function initialize(rootViewController:ViewController):DeepLinkNavigationController
		{
			_rootViewController = rootViewController;
			return instance();
		}

		public static function instance():DeepLinkNavigationController
		{
			if (_rootViewController == null)
				throw new Error("最初に initialize メソッドを呼び出してください");
			if (_instance == null)
				_instance = new DeepLinkNavigationController(new SingletonEnforcer(), _rootViewController);
			return _instance;
		}

		/**
		 * シーンマネージャー.
		 * @return
		 *
		 */
		public function get sceneManager():ISceneProvider
		{
			if (_sceneManager == null)
			{
				_sceneManager = new SceneManager();
			}
			return _sceneManager;
		}

		/**
		 * @inheritDoc
		 */
		override public function pushViewController(viewController:IViewController):Boolean
		{
			var isRootViewController:Boolean = numViewControllers == 0;

			var success:Boolean = super.pushViewController(viewController);
			if (!success)
				return success;

			if (!isRootViewController)
			{
				var link:IDeepLinkableViewController = viewController as IDeepLinkableViewController;
				var val:String = SWFAddress.getValue() == "/" ? SWFAddress.getValue() + link.sceneID : SWFAddress.getValue() + "/" + link.sceneID;
				_currentPath = val;
				SWFAddress.setValue(val);

				var paths:Array = SWFAddress.getPathNames();
			}

			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function popViewController():IViewController
		{
			var poped:IViewController = super.popViewController();

			var paths:Array = _currentPath.split("/");

			var id:String = paths[paths.length - 1];

			if (_sceneManager.getSceneByID(id) != null)
				_currentPath = _currentPath.substr(0, _currentPath.length - paths[paths.length - 1].length - 1);

			SWFAddress.setValue(_currentPath);
			NotificationCenter.instance().postNotification(new Notification("SWFAddressChange", this));
			return poped;
		}

		override public function popToRootViewController():void
		{
			super.popToRootViewController();
			var paths:Array = SWFAddress.getPathNames();
			var numScenes:int = _sceneManager.numScenes;
			var val:String;
			for (var i:int = 0; i < paths.length; i++)
			{
				if (_sceneManager.getSceneByID(paths[i]) != null)
				{
					//trace("splice : ", paths[i]);
					paths.splice(i, 1);
					i--;
				}
			}
			val = "/" + paths.join("/");

			SWFAddress.setValue("");
		}

		private function isRootViewController():Boolean
		{
			return navigationController == null && view.parent != null;
		}

		private function swfAddressChangeListener(e:SWFAddressEvent):void
		{
			var minus:Array = getToMinus()
			var plus:Array = getToPlus();

			for (var i:int = minus.length - 1; i >= 0; i--)
			{
				if (_sceneManager.getSceneByID(minus[i]))
					super.popViewController();
			}

			for (var j:int = 0; j < plus.length; j++)
			{
				super.pushViewController(_sceneManager.getSceneByID(plus[j]));
			}

			_currentPath = SWFAddress.getValue();
		}

		private function getToMinus():Array
		{
			var ret:Array = new Array();
			var old:Array = _currentPath.split("/");
			var nowPath:String = SWFAddress.getValue()
			if (nowPath.charAt(nowPath.length - 1) == "/")
				nowPath = nowPath.substr(0, nowPath.length - 2);
			var now:Array = nowPath.split("/");

			var num:int = old.length;

			for (var i:int = 0; i < num; i++)
			{
				if (old[i] != now[i])
				{
					break;
				}
			}

			ret = old.slice(i, old.length);
			return ret;
		}

		private function getToPlus():Array
		{
			var ret:Array = new Array();
			var old:Array = _currentPath.split("/");
			var nowPath:String = SWFAddress.getValue()
			if (nowPath.charAt(nowPath.length) == "/")
				nowPath = nowPath.substr(0, nowPath.length - 1);
			var now:Array = nowPath.split("/");

			var num:int = old.length;
			for (var i:int = 0; i < num; i++)
			{
				if (old[i] != now[i])
				{
					break;
				}
			}

			if (nowPath == "/")
				return ret;

			ret = now.splice(i, now.length);
			return ret;
		}

	}
}

internal class SingletonEnforcer
{
}