package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Frame;
	
	import as3_user_interface_kit.events.ScrollEvent;
	import as3_user_interface_kit.views.AbstractScrollBarView;
	import as3_user_interface_kit.views.ScrollView;
	import as3_user_interface_kit.views.View;

	/**
	 * スクロール領域のビューコンポーネント.
	 * @author takanosatoshi
	 */
	public class ScrollViewController extends ViewController
	{
		private var _scrollBarController:ScrollBarController;
		private var _scrollView:ScrollView;

		private var _scrollDirection:int = 0;

		/**
		 * 引数にスクロールバービューコンポーネントを渡して、スクロール領域ビューコンポーネントを作成します.
		 * <p>引数には<code>HorizontalScrollBarView</code>または<code>VerticalScrollBarView</code>を渡します。</br>
		 * どちらかのタイプに応じて、自動で横スクロールか縦スクロールの機能が提供されます。</p>
		 * @param scrollBarView
		 * @see as3_user_interface_kit.views.HorizontalScrollBarView
		 * @see as3_user_interface_kit.views.VerticalScrollBarView
		 */
		public function ScrollViewController(scrollBarView:AbstractScrollBarView, borderWidth:int = 0)
		{
			super();
			_scrollView = new ScrollView();
			_scrollDirection = scrollBarView.type;

			this.view = _scrollView;

			_scrollBarController = new ScrollBarController(scrollBarView);
			_scrollView.maskPadding = borderWidth;
			this.view.addChild(_scrollBarController.view);
		}

		private function update():void
		{
			_scrollBarController.contentSize = Math.max(_scrollView.sourceLayer.height, _scrollBarController.contentSize);
			_scrollBarController.isEnabled = _scrollBarController.needVisibility;
			if (_scrollBarController.isEnabled)
			{
				var scrollBarViewFrame:Frame = _scrollBarController.view.frame;
				if (_scrollDirection == AbstractScrollBarView.VERTICAL)
				{
					scrollBarViewFrame.height = _scrollView.height;
					scrollBarViewFrame.x = _scrollView.width - scrollBarViewFrame.width;
					//scrollBarViewFrame.y = _scrollView.y;
				}
				else
				{
					scrollBarViewFrame.width = _scrollView.maskFrame.width;
					scrollBarViewFrame.x = _scrollView.maskFrame.x;
					scrollBarViewFrame.y = _scrollView.maskFrame.height - scrollBarViewFrame.height;
				}

			}
		}

		/**
		 * @inheritDoc
		 */
		override public function viewDidAppear():void
		{
			_scrollBarController.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
			super.viewDidAppear();
			update();
			_scrollBarController.view.setNeedDisplay();

			_scrollBarController.setMouseWheelListener(view);
		}

		/**
		 * @inheritDoc
		 */
		override public function viewDidDisappear():void
		{
			_scrollBarController.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);

			_scrollBarController.removeMouseWheelListener(view);
		}

		/**
		 * スクロール対象領域にビューオブジェクトを追加
		 */
		public function addContentView(view:View):void
		{
			_scrollView.addChildToMaskedPane(view);

			if (_scrollDirection == AbstractScrollBarView.VERTICAL)
				_scrollBarController.contentSize = view.frame.height;
			else
				_scrollBarController.contentSize = view.frame.width;

			update();
			_scrollBarController.view.setNeedDisplay();
		}

		/**
		 * スクロールバーへの参照.
		 * @return
		 *
		 */
		public function get scrollBar():ScrollBarController
		{
			return _scrollBarController;
		}

		/**
		 * スクロールバーがスクロールされたときに呼び出されます.
		 * <p>スクロールにトランジションを適用したい場合などは、このメソッドをオーバーライドしてそのなかで処理します。</p>
		 */
		protected function scrollUpdate(e:ScrollEvent):void
		{
			if (_scrollDirection == AbstractScrollBarView.VERTICAL)
				_scrollView.sourceLayer.y = -(_scrollView.sourceLayer.height - _scrollView.maskFrame.height) * _scrollBarController.scrollRatio + _scrollView.maskLayer.y;
			else
				_scrollView.sourceLayer.x = -(_scrollView.sourceLayer.width - _scrollView.maskFrame.width) * _scrollBarController.scrollRatio + _scrollView.maskLayer.x;
		}

		/**
		 * スクロールビューを返します.
		 * @return
		 *
		 */
		protected function get scrollView():ScrollView
		{
			return _scrollView;
		}
	}
}
