package as3_user_interface_kit.views
{
	import as3_animation_kit.NumericalInterpolator;
	import as3_animation_kit.events.AnimationEvent;
	
	import as3_user_interface_kit.Application;
	import as3_user_interface_kit.Frame;
	import as3_foundation.dvbinternal;
	
	import as3_user_interface_kit.appearances.IScrollBarViewSkin;
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.events.ScrollEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="scrollUpdate", type="as3_user_interface_kit.events.ScrollEvent")]

	use namespace dvbinternal;

	/**
	 * @author takanosatoshi
	 */
	public class VerticalScrollBarView extends AbstractScrollBarView
	{
		private var _scrollRatioInterpolate:NumericalInterpolator;
		public var handleViewBorderThickness:int = 0;
		public var fixHandleViewHeigh:Boolean = false;
		private var _interp:NumericalInterpolator;
		private var _scrollRatio:Number = 0;

		public function VerticalScrollBarView(config:IScrollBarViewSkin):void
		{
			super(AbstractScrollBarView.VERTICAL);

			setRail(config.getRail());
			setHandle(config.getHandle());
			setButton(config.getUpButton(), config.getDownButton());
		}

		override public function run():void
		{
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);
			_handle.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_rail.addEventListener(MouseEvent.CLICK, railClickHandler);
			Application.getDocumentClass().stage.addEventListener(MouseEvent.MOUSE_UP, stopScroll);
		}

		override public function stop():void
		{
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, startScroll);
			_handle.removeEventListener(MouseEvent.MOUSE_UP, stopScroll);
			_rail.removeEventListener(MouseEvent.CLICK, railClickHandler);
		}

		private var _trackMouseoffset:Number = 0;

		private function startScroll(e:MouseEvent):void
		{
			Application.getDocumentClass().stage.addEventListener(MouseEvent.MOUSE_MOVE, handleDragListener);
			_trackMouseoffset = _handle.mouseY;
		}

		private function stopScroll(e:MouseEvent):void
		{
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleDragListener);
		}

		private function handleDragListener(e:MouseEvent):void
		{
			updateHandlePositionAndScrollRatio(mouseY - _trackMouseoffset);
		}

		override dvbinternal function setHandlePosition(value:Number):void
		{
			updateHandlePositionAndScrollRatio(value);
		}

		private function updateHandlePositionAndScrollRatio(handlePosition:Number):void
		{
			var hy:Number = handlePosition;
			var ratio:Number = 0;

			// 2回以上アクセスする物はオーバーヘッドを減らすため変数にいれる.
			var handleViewFrame:Frame = _handle.frame;
			var railFrame:Frame = _rail.frame;

			if (hy < railFrame.y)
				ratio = 0;
			else
				ratio = (hy - railFrame.y) / (railFrame.height - handleViewFrame.height);
			if (ratio > 1)
				ratio = 1;

			scrollRatio = ratio;
		}

		override dvbinternal function get scrollRatio():Number
		{
			return _scrollRatio;
		}

		override dvbinternal function set scrollRatio(value:Number):void
		{
			if (value > 1)
				value = 1;
			else if (value < 0)
				value = 0;

			var tmpY:int = _upBtnView.frame.height + (_rail.frame.height - _handle.frame.height) * value;
			//var tmpY:int = _upBtnView.frame.height + (_rail.frame.height - _handle.frame.height + handleViewBorderThickness * 2) * value - handleViewBorderThickness;
			_handle.y = tmpY;

			if (!hasEventListener(Event.ENTER_FRAME))
			{
				addEventListener(Event.ENTER_FRAME, interpolateScrollRatio);
			}

			_interp = new NumericalInterpolator(value, _scrollRatio, transitionSteps, easing);
			_scrollRatio = _interp.next();
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE, false));
		}

		override protected function draw():void
		{
			super.draw();

			//var oldRatio:Number = scrollRatio;
			var w:Number = frame.width;
			var h:Number = frame.height;

			var upBtnViewFrame:Frame = _upBtnView.frame;
			var dwBtnViewFrame:Frame = _downBtnView.frame;
			var handleViewFrame:Frame = _handle.frame;
			var railFrame:Frame = _rail.frame;

			upBtnViewFrame.width = upBtnViewFrame.height = _upBtnView.visible ? w : 0;
			dwBtnViewFrame.width = dwBtnViewFrame.height = _downBtnView.visible ? w : 0;
			dwBtnViewFrame.y = (h - w < 0) ? 0 : h - w;

			//railFrame.width = w;
			railFrame.x = (width - railFrame.width) * 0.5;
			railFrame.y = upBtnViewFrame.height;
			railFrame.height = h - upBtnViewFrame.height - dwBtnViewFrame.height;
			var tmpH:Number = railFrame.height * (h / contentSize);

			if (tmpH > h)
				tmpH = h;
			if (isNaN(tmpH) || tmpH == Infinity || tmpH < 10)
				tmpH = 10;

			if (!fixHandleViewHeigh) handleViewFrame.height = tmpH;
			//scrollRatio = oldRatio;

			handleViewFrame.width = w;

			_rail.setNeedDisplay();

			var minY:Number = railFrame.y - handleViewBorderThickness;
			var maxY:Number = railFrame.y + railFrame.height + handleViewBorderThickness;
			if (handleViewFrame.y < minY)
				handleViewFrame.y = minY;
			else if (handleViewFrame.y + handleViewFrame.height > maxY)
				handleViewFrame.y = maxY;

			_handle.setNeedDisplay();
			_upBtnView.setNeedDisplay();
			_downBtnView.setNeedDisplay();
		}

		private function interpolateScrollRatio(e:Event):void
		{
			_scrollRatio = _interp.next();
			if (_interp.isEnd)
			{
				removeEventListener(Event.ENTER_FRAME, interpolateScrollRatio);
				_interp = null;
				dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
			}
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE, false));
		}

		private function railClickHandler(e:MouseEvent):void
		{
			var offset:Number = railSize / 10;
			if (_handle.frame.y > mouseY)
				offset *= -1;
			setHandlePosition(_handle.y + offset);
		}

		override public function get upBtn():ButtonController
		{
			return _upBtn;
		}

		override public function get downBtn():ButtonController
		{
			return _downBtn;
		}

	}
}
