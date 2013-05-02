package as3_user_interface_kit.controllers
{
	import as3_foundation.utils.Capture;
	
	import as3_user_interface_kit.events.DragDropEvent;
	import as3_user_interface_kit.views.View;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="changeReception", type="as3_user_interface_kit.events.DragDropEvent")]
	[Event(name="startDrag", type="as3_user_interface_kit.events.DragDropEvent")]
	[Event(name="stopDrag", type="as3_user_interface_kit.events.DragDropEvent")]
	/**
	 */
	public class DragItemController extends ViewController implements IDraggableViewController
	{
		private var _itemData:Object;
		// 受け入れ先オブジェクト
		private var _reception:DragReceptionController;

		private var _dragDistanceThreshould:int = 10;
		// ドラッグ開始するのに、マウスダウンしながら動かす必要がある距離
		private var _dragTimeThreshould:int = 200;
		// ドラッグ開始するのに、マウスダウンしたままにする必要がある時間
		private var _timer:Timer;
		// ドラッグとクリックを、マウスダウンの経過時間で判定する.
		private var _parentItem:View;
		private var _mouseXAtMouseDown:Number;
		private var _mouseYAtMouseDown:Number;

		private var _ghost:View;
		private var _dropEnabled:Boolean;

		/**
		 * コンストラクタ.
		 */
		public function DragItemController(src:View)
		{
			super();

			view.useHandCursor = true;
			view.addChild(src);

			_ghost = new View();

			_ghost.mouseEnabled = true;
			view.buttonMode = true;
		}


		/**
		 * @inheritDoc
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			_ghost.frame.x = view.frame.x;
			_ghost.frame.y = view.frame.y;

			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_ghost.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		override public function viewDidDisappear():void
		{
			view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_ghost.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (_timer)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		/**
		 * @inheritDoc
		 */
		public function onDrag():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function onDrop():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function get dropEnabled():Boolean
		{
			return _dropEnabled;
		}

		public function set dropEnabled(can:Boolean):void
		{
			_dropEnabled = can;
		}

		/**
		 * @inheritDoc
		 */
		public function onCancel():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function get reception():DragReceptionController
		{
			return _reception;
		}

		public function set reception(rec:DragReceptionController):void
		{
			if (_reception === rec)
				return;
			_reception = rec;

			dispatchEvent(new DragDropEvent(DragDropEvent.CHANGE_RECEPTION));
		}

		/**
		 * @inheritDoc
		 */
		public function get ghost():View
		{
			while (_ghost.numChildren)
			{
				_ghost.removeChildAt(0);
			}
			_ghost.addChild(new Bitmap(Capture.getBitmapData(view)));
			_ghost.sizeToFit();
			return _ghost;
		}

		private function onMouseDown(e:MouseEvent):void
		{
			_timer = new Timer(_dragTimeThreshould, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();

			_mouseXAtMouseDown = view.mouseX;
			_mouseYAtMouseDown = view.mouseY;
			view.addEventListener(Event.ENTER_FRAME, checkMouseMove);
		}

		private function onMouseUp(e:MouseEvent):void
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);

				view.removeEventListener(Event.ENTER_FRAME, checkMouseMove);
				return;
			}

			dispatchEvent(new DragDropEvent(DragDropEvent.STOP_DRAG));
		}

		private function checkMouseMove(e:Event):void
		{
			if (Math.abs(_mouseXAtMouseDown - view.mouseX) > _dragDistanceThreshould || Math.abs(_mouseYAtMouseDown - view.mouseY) > _dragDistanceThreshould)
			{
				view.removeEventListener(Event.ENTER_FRAME, checkMouseMove);
				onTimerComplete(null);
			}
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_timer = null;
			}
			view.removeEventListener(Event.ENTER_FRAME, checkMouseMove);

			var evt:DragDropEvent = new DragDropEvent(DragDropEvent.START_DRAG);
			evt.dragging = this;
			dispatchEvent(evt);
		}
	}
}