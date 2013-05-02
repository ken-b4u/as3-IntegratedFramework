package as3_user_interface_kit.views
{
	import as3_user_interface_kit.controllers.ViewController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import as3_foundation.dvbinternal;
	
	/**
	 * Window オブジェクトに ModalView オブジェクトを与えることで、一時的に Window オブジェクトのインタラクションを無効にし、
	 * ダイアログなどの入力を促すことができます。
	 * @see Window
	 */
	public class ModalView extends View
	{
		private var _viewController:ViewController;
		private var _clearCover:DrawableView;

		/**
		 * コンストラクタ.
		 */
		public function ModalView()
		{
			_clearCover = new DrawableView(0, 0);
			_clearCover.alpha = 0.2;
			blockInteraction = true;
			addChild(_clearCover);
		}
		
		public function set useCover(b:Boolean):void {
			if (!b) {
				_clearCover.visible = false;
			} else {
				_clearCover.visible = true;
				_clearCover.alpha = 0.2;
			}
		}

		/**
		 * @return この ModalView が追加される Window オブジェクトです.
		 *
		 */
		public function get viewController():ViewController
		{
			return _viewController;
		}

		public function set viewController(window:ViewController):void
		{
			_viewController = window;
			frame.set(0, 0, _viewController.view.frame.width, _viewController.view.frame.height);
		}

		/**
		 * 表示される時に呼び出されます.
		 * 通常このメソッドでアニメーションなどを開始します。
		 */
		public function show():void
		{

		}

		use namespace dvbinternal;

		/**
		 * 非表示になる時に呼び出されます.
		 */
		public function hide():void
		{
			dispatchEvent(new Event(Event.CLOSE));
			viewController.removeModalView();
		}

		/**
		 * ユーザー操作を無効にする半透明のSprite.
		 */
		protected function get interactionBarrier():DrawableView
		{
			return _clearCover;
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
			if (_viewController)
			{
				_clearCover.width = frame.width;
				_clearCover.height = frame.height;
			}
		}

		public function get blockInteraction():Boolean
		{
			return _clearCover.mouseEnabled;
		}

		public function set blockInteraction(doBlock:Boolean):void
		{
			_clearCover.mouseChildren = !doBlock;
			_clearCover.mouseEnabled = doBlock;
		}
	}
}