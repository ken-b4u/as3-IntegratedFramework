package as3_user_interface_kit.controllers
{
	import as3_foundation.dvbinternal;
	
	import as3_user_interface_kit.events.ExMouseEvent;
	import as3_user_interface_kit.events.ScrollEvent;
	import as3_user_interface_kit.views.AbstractScrollBarView;
	import as3_user_interface_kit.views.View;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	[Event(name="scrollUpdate", type="as3_user_interface_kit.events.ScrollEvent")]

	/**
	 * スクロールバーのコントローラ.
	 * <p>スクロール比率を変化させるためのボタン操作や、バーのレールをクリックしたときの挙動、 スクロールする内容のサイズに応じたハンドルサイズ変化など、
	 * スクロールバーのユーザビリティを高めるための機能を実装しています。</p>
	 * <p>サイズから、表示擦る必要があるかどうかや、計算したスクロール比率などの情報を提供します。</p>
	 * @author takanosatoshi
	 *
	 */
	public class ScrollBarController extends ViewController
	{
		/**
		 * @private
		 * マウスホイールイベントの範囲となる表示オブジェクトです.
		 */
		protected var _mouseWheelTargets:Vector.<InteractiveObject>;
		private var _mouseWheelEanabled:Boolean = false;

		private var _scrollBarView:AbstractScrollBarView;
		private var _downBtn:ButtonController;
		private var _upBtn:ButtonController;
		private var _upBtnView:View;
		private var _downBtnView:View;

		use namespace dvbinternal;

		/**
		 * 引数にスクロールバービューコンポーネントを渡して、スクロールバーのコントローラを作成します.
		 * <p>引数には<code>HorizontalScrollBarView</code>または<code>VerticalScrollBarView</code>を渡します。</p>
		 * @param scrollBarView
		 * @see as3_user_interface_kit.views.HorizontalScrollBarView
		 * @see as3_user_interface_kit.views.VerticalScrollBarView
		 */
		public function ScrollBarController(view:AbstractScrollBarView)
		{
			_scrollBarView = view;

			_upBtn = _scrollBarView.upBtn;
			_downBtn = _scrollBarView.downBtn;

			_upBtnView = _upBtn.view;
			_downBtnView = _downBtn.view;

			this.view = _scrollBarView;
			_mouseWheelTargets = new Vector.<InteractiveObject>();
		}

		/**
		 * スクロールバーのビューコンポーネント.
		 * @return
		 *
		 */
		public function get scrollBarView():AbstractScrollBarView
		{
			return _scrollBarView;
		}

		/**
		 * @inheritDoc
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			_scrollBarView.run();

			_scrollBarView.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollViewDidUpdate);
			_upBtnView.addEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			_upBtn.addEventListener(ExMouseEvent.MOUSE_DOWN_LONG_TIME, repeat);
			_downBtnView.addEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			_downBtn.addEventListener(ExMouseEvent.MOUSE_DOWN_LONG_TIME, repeat);
		}

		/**
		 * @inheritDoc
		 */
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			_scrollBarView.stop();


			_scrollBarView.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollViewDidUpdate);
			_upBtnView.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			_upBtn.removeEventListener(ExMouseEvent.MOUSE_DOWN_LONG_TIME, repeat);
			_downBtnView.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown);
			_downBtn.removeEventListener(ExMouseEvent.MOUSE_DOWN_LONG_TIME, repeat);
		}

		private function scrollViewDidUpdate(e:ScrollEvent):void
		{
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE, false));
		}

		/**
		 * マウスホイールの回転を受け付ける表示オブジェクトを設定します.
		 * @param value
		 *
		 */
		public function setMouseWheelListener(target:InteractiveObject):void
		{
			_mouseWheelEanabled = true;
			var already:Boolean = false;
			for each(var t:InteractiveObject in _mouseWheelTargets) already = (t == target);
			if (!already) {
				_mouseWheelTargets.push(target);
				target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}

		/**
		 * マウスホイールの回転を受け付ける表示オブジェクトを設定解除します.
		 * @param value
		 *
		 */
		public function removeMouseWheelListener(target:InteractiveObject):void
		{
			var c:int = 0;
			for each(var t:InteractiveObject in _mouseWheelTargets) {
				if (t == target) {
					_mouseWheelTargets.splice(c++, 1);
					target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					break;
				}
			}
			if (_mouseWheelTargets.length == 0) _mouseWheelEanabled = false;
		}

		/**
		 * スクロール対象のサイズ.
		 * @return
		 *
		 */
		public function get contentSize():Number
		{
			return _scrollBarView.contentSize;
		}

		/**
		 * @inheritDoc
		 * @param value
		 *
		 */
		public function set contentSize(value:Number):void
		{
			_scrollBarView.contentSize = value;
		}

		/**
		 * スクロールバーの機能のアクティブ/デアクティブ.
		 * @param value
		 *
		 */
		public function get isEnabled():Boolean
		{
			return view.visible;
		}

		public function set isEnabled(value:Boolean):void
		{
			view.visible = value;
		}

		public function activate():void
		{
			if (!_mouseWheelEanabled)
			{
				_mouseWheelEanabled = true;
				for each(var t:InteractiveObject in _mouseWheelTargets) t.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				view.mouseEnabled = true;
				view.mouseChildren = true;
			}
		}

		public function deactivate():void
		{
			_mouseWheelEanabled = false;
			for each(var t:InteractiveObject in _mouseWheelTargets) t.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			view.mouseEnabled = false;
			view.mouseChildren = false;
		}

		/**
		 * 現在のスクロール比.(0〜1)
		 * @param value
		 *
		 */
		public function get scrollRatio():Number
		{
			return _scrollBarView.scrollRatio;
		}

		/**
		 * @inheritDoc
		 * @param value
		 *
		 */
		public function set scrollRatio(value:Number):void
		{
			/*var pos:Number = _scrollBarView.railPosition + ((_scrollBarView.railSize - _scrollBarView.handleSize) * value);
			_scrollBarView.setHandlePosition(0);
			trace(pos);*/
			_scrollBarView.scrollRatio = value;
		}

		/**
		 * スクロールバーを使う必要があるかどうかの真偽値.
		 * <p>スクロールバーのサイズより内容のほうが大きい場合は<code>true</code>そうでなければ<code>false</code></p>
		 * @return
		 *
		 */
		public function get needVisibility():Boolean
		{
			return contentSize > view.frame.height;
		}

		private function btnDown(e:MouseEvent):void
		{
			var b:View = e.target as View;
			if (b == null)
				b = e.target.view;

			var ratio:Number = scrollRatio;
			if (b == _upBtnView)
				_scrollBarView.setHandlePosition(_scrollBarView.handlePosition - (_scrollBarView.railSize - _scrollBarView.handleSize) / 9);
			else
				_scrollBarView.setHandlePosition(_scrollBarView.handlePosition + (_scrollBarView.railSize - _scrollBarView.handleSize) / 9);
		}

		private function repeat(e:ExMouseEvent):void
		{
			btnDown(e);
		}

		private function onMouseWheel(e:MouseEvent):void
		{
			if (needVisibility)
			{
				var delta:Number = e.delta / 2;
				_scrollBarView.setHandlePosition(_scrollBarView.handlePosition - delta);
			}
		}
	}
}