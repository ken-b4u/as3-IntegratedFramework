package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Frame;
	import as3_foundation.log.Logger;
	
	import as3_user_interface_kit.events.ViewControllerEvent;
	import as3_user_interface_kit.views.View;

	/**
	 * <code>NavigationController</code>.
	 * <p><code>NavigationController</code>はビューの直列型遷移を管理します。</p>
	 * @author tkn
	 *
	 */
	public class NavigationController extends ViewController
	{
		private var _viewControllers:Array;
		private var _topViewController:IViewController;
		private var _viewContainer:View;

		private var _rootViewController:IViewController;

		// 高速でpopしてviewが非表示になるアニメーション最中にpushされた時に、
		// 非表示になるまで待たせとくための変数.
		private var _queueViewController:IViewController;

		/**
		 * コンストラクタ.
		 *
		 */
		public function NavigationController(rootViewControlelr:IViewController)
		{
			super();
			_viewControllers = new Array();
			_viewContainer = new View();
			view.addChild(_viewContainer);

			_rootViewController = rootViewControlelr;
			pushViewController(_rootViewController);
		}

		/**
		 * @inheritDoc
		 *
		 */
		override public function viewWillDraw():void
		{
			super.viewWillDraw();
			var cvcvf:Frame = _currentVisible.view.frame;
			var vf:Frame = view.frame;
			cvcvf.width = vf.width;
			cvcvf.height = vf.height;
			_currentVisible.view.setNeedDisplay();
		}

		/**
		 * 管理する<code>IViewController</code>を配列の形でセットします.
		 * <p>iOS UIKit framework の UINavigationController には rootViewController という概念がありますが、
		 * この<code>NavigationController</code>には root という概念はありません。</p>
		 * @param viewControllers
		 *
		 */
		public function setViewControlelrs(viewControllers:Array):void
		{
			_viewControllers = viewControllers;
			_topViewController = _viewControllers[_viewControllers.length - 1];

			var numViewControllers:int = numViewControllers;
			for (var i:int = 0; i < numViewControllers; i++)
			{
				var vc:IViewController = _viewControllers[i];
				vc.navigationController = this;
				if (i > 0)
					vc.parentViewController = _viewControllers[i - 1];
			}

			moveViewController(_viewControllers[numViewControllers - 1]);
		}

		/**
		 * <code>IViewController</code>を管理対象として、配列の最後尾に追加します.
		 * <p>現在表示されている<code>view</code>の<code>controller</code>を追加することはできません。
		 * 追加しようとした場合には<code>false</code>が返されます。</p>
		 * @param viewController
		 *
		 */
		public function pushViewController(viewController:IViewController):Boolean
		{
			if (_topViewController == viewController)
			{
				Logger.instance().warn("引数に渡された IViewController は現在表示中です。新たに追加は出来ません。");
				return false;
			}


			viewController.navigationController = this;
			if (_viewControllers.length)
				viewController.parentViewController = _viewControllers[numViewControllers - 1];
			_viewControllers.push(viewController);

			// 非表示アニメーションの最中だったら終了まで待たせておく.
			if (!_removing)
				moveViewController(viewController);
			else
				_queueViewController = viewController;

			return true;
		}

		/**
		 * 最も最近追加された<code>IViewController</code>管理対象配列から削除します.
		 *
		 */
		public function popViewController():IViewController
		{
			if (numViewControllers <= 1)
				return null;

			var poped:IViewController = _viewControllers.pop();
			if (poped == null)
				return null;

			poped.navigationController = null;
			poped.parentViewController = null;

			// 非表示アニメーションの最中だったら、データは削除するがアニメーションはさせない.
			if (!_removing)
				moveViewController(_viewControllers[numViewControllers - 1]);


			return poped;
		}

		/**
		 * 2回目以降に追加された<code>IViewController</code>を管理対象配列から削除します.
		 *
		 */
		public function popToRootViewController():void
		{
			var length:int = _viewControllers.length;
			var isPoped:Boolean = false;
			while (_viewControllers.length > 1)
			{
				var poped:IViewController = _viewControllers.pop();
				poped.navigationController = null;
				poped.parentViewController = null;
				isPoped = true;
			}

			if (isPoped)
				moveViewController(_viewControllers[numViewControllers - 1]);
		}

		/**
		 * 引数に渡された<code>IViewController</code>以降の<code>IViewController</code>を管理対象配列から削除します.
		 * @param viewController
		 *
		 */
		public function popToViewController(viewController:IViewController):void
		{
			var n:int = numViewControllers - 1;
			var i:int;
			for (i = 0; i < n; i++)
			{
				var vc:IViewController = _viewControllers[i];
				if (vc != viewController)
					continue;
				else
					break;
			}

			var len:int = n - i;
			for (var j:int = 0; j < len; j++)
			{
				var poped:IViewController = _viewControllers.pop();
				poped.navigationController = null;
				poped.parentViewController = null;
			}

			if (len)
				moveViewController(_viewControllers[numViewControllers - 1]);
		}

		private var _currentVisible:IViewController;
		private var _removing:Boolean = false;

		private function moveViewController(viewController:IViewController):void
		{
			viewController.view.frame.set(0, 0, view.frame.width, view.frame.height);
			_currentVisible = viewController;

			if (_topViewController)
			{
				_removing = true;
				_topViewController.addEventListener(ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY, remove);
				// 連続で popViewController された時の対応.
				// if (_viewContainer.contains(_topViewController.view))
				_viewContainer.removeChild(_topViewController.view);
			}
			else
			{
				if (viewController && _viewContainer.numChildren == 0)
				{
					_viewContainer.addChild(viewController.view);
					_topViewController = viewController;
				}
			}

		}

		private function remove(e:ViewControllerEvent):void
		{
			_removing = false;
			var nowRemoving:IViewController = e.target as IViewController;
			nowRemoving.removeEventListener(ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY, remove);

			// 追加待ちのがあったらそっち追加.
			if (_queueViewController)
			{
				_topViewController = _queueViewController;
				_currentVisible = _queueViewController;
				_currentVisible.view.frame.set(0, 0, view.frame.width, view.frame.height);
				_viewContainer.addChild(_currentVisible.view);
				_queueViewController = null;
			}
			else if (_currentVisible)
			{
				_viewContainer.addChild(_currentVisible.view);
				_topViewController = _currentVisible;
			}
		}



		/**
		 * 現在表示されている<code>view</code>のコントローラ.
		 * @return
		 *
		 */
		public function get topViewController():IViewController
		{
			return _topViewController;
		}

		/**
		 * 管理対象の<code>IViewController</code>インスタンスの数.
		 * @return
		 *
		 */
		public function get numViewControllers():int
		{
			return _viewControllers.length;
		}

		/**
		 * 管理対象の<code>IViewController</code>が入っている配列.
		 * @return
		 *
		 */
		private function get viewControllers():Array
		{
			return _viewControllers;
		}

	}
}