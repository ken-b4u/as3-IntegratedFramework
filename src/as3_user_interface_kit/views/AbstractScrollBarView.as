package as3_user_interface_kit.views
{
	import as3_animation_kit.IEasing;
	import as3_animation_kit.interpolator.RPExpo;
	
	import as3_user_interface_kit.Application;
	import as3_foundation.dvbinternal;
	
	import as3_user_interface_kit.controllers.ButtonController;

	use namespace dvbinternal

	public class AbstractScrollBarView extends View
	{
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1;
		
		public var transitionSteps:int = Application.frameRate / 2;
		/**
		 * スクロールバーのタイプ(VERTICAL || HORIZONTAL)
		 */
		public var type:int;
		public var contentSize:Number;

		/**
		 *  @private
		 */
		protected var _rail:View;
		/**
		 *  @private
		 */
		protected var _upBtn:ButtonController;
		/**
		 *  @private
		 */
		protected var _downBtn:ButtonController;
		/**
		 *  @private
		 */
		protected var _handle:View;

		/**
		 *  @private
		 */
		protected var _upBtnView:View;
		/**
		 *  @private
		 */
		protected var _downBtnView:View;

		private var _easing:IEasing;

		public function AbstractScrollBarView(type:int)
		{
			this.type = type;
			_easing = RPExpo.easeOut();
			super();
		}

		public function get easing():IEasing
		{
			return _easing;
		}

		public function set easing(easeFunc:IEasing):void
		{
			_easing = easeFunc;
		}


		/**
		 * @private
		 * スクロールバーの処理を開始します.
		 */
		public function run():void
		{

		}

		/**
		 * @private
		 * スクロールバーの処理を停止します.
		 */
		public function stop():void
		{
		}

		public function get upBtn():ButtonController
		{
			return _upBtn;
		}

		public function get downBtn():ButtonController
		{
			return _downBtn;
		}


		protected function setRail(rail:View):void
		{
			this._rail = rail;
			this._rail.mouseEnabled = true;
			addChild(this._rail);
		}

		protected function setHandle(handle:View):void
		{
			_handle = handle;
			addChild(_handle);
			_handle.buttonMode = true;
		}

		protected function setButton(up:ButtonController, down:ButtonController):void
		{
			_upBtn = up;
			_upBtnView = _upBtn.view;
			_downBtn = down;
			_downBtnView = _downBtn.view;
			addChild(_upBtnView);
			addChild(_downBtnView);
		}

		/**
		 * @private
		 */
		dvbinternal function setHandlePosition(value:Number):void
		{

		}

		dvbinternal function get handleSize():Number
		{
			var size:Number;
			size = type == VERTICAL ? _handle.frame.height : _handle.frame.width;
			return size;
		}

		dvbinternal function get handlePosition():Number
		{
			return type == VERTICAL ? _handle.frame.y : _handle.frame.x;
		}

		dvbinternal function get railPosition():Number
		{
			var position:Number;
			position = type == VERTICAL ? _rail.frame.y : _rail.frame.x;
			return position;
		}

		dvbinternal function get railSize():Number
		{
			return type == VERTICAL ? _rail.height - _upBtnView.frame.height - _downBtnView.frame.height : _rail.width - _upBtnView.frame.width - _downBtnView.frame.width;
		}

		dvbinternal function get scrollRatio():Number
		{
			return 0;
		}

		dvbinternal function set scrollRatio(val:Number):void
		{

		}
	}
}