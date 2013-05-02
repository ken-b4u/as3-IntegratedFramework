package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Application;
	import as3_foundation.dvbinternal;
	
	import as3_user_interface_kit.appearances.ISliderSkin;
	import as3_user_interface_kit.events.ScrollEvent;
	import as3_user_interface_kit.views.View;
	
	import flash.events.MouseEvent;

	[Event(name="scrollUpdate", type="as3_user_interface_kit.events.ScrollEvent")]
	
	public class SliderController extends ViewController
	{
		public static const VERTICAL:int = 0;
		public static const HORIZONTAL:int = 1;
		
		dvbinternal var rail:View;
		dvbinternal var handle:View;
		
		private var _offset:Number;
		private var _mode:int;
		
		use namespace dvbinternal;
		
		public function SliderController(skin:ISliderSkin, mode:int)
		{
			super();
			
			_mode = mode;
			
			rail = skin.getRail();
			view.addChild(rail);
			
			handle = skin.getHandle();

			view.addChild(handle);
		}
		
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			handle.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			handle.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			rail.addEventListener(MouseEvent.CLICK, railClickListener);
			Application.getDocumentClass().stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			handle.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			handle.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			rail.removeEventListener(MouseEvent.CLICK, railClickListener);
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		override public function viewWillDraw():void
		{
			super.viewWillDraw();
			rail.width = view.width;
			rail.height = view.height;
			if (_mode)
				handle.y = (rail.height - handle.height) / 2;
			else
				handle.x = (rail.width - handle.width) / 2;
		}
		
		public function get ratio():Number
		{
			var res:Number;
			if (_mode)
				res = handle.x / (rail.width - handle.width);
			else
				res = handle.y / (rail.height - handle.height);
			return res;
		}
		
		public function set ratio(r:Number):void
		{
			if (_mode)
				handle.x = (rail.width - handle.width) * r;
			else
				handle.y = (rail.height - handle.height) * r;
		}
		
		private function mouseDownListener(e:MouseEvent):void
		{
			Application.getDocumentClass().stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			_offset = _mode ? handle.mouseX : handle.mouseY;
		}
		
		private function mouseUpListener(e:MouseEvent):void
		{
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
		}
		
		private function railClickListener(e:MouseEvent):void
		{
			if (_mode)
			{
				handle.x = view.mouseX - handle.width / 2;
				if (handle.x < 0)
					handle.x = 0;
				else if (handle.x > view.width - handle.width)
					handle.x = view.width - handle.width;
			}
			else
			{
				handle.y = view.mouseY - handle.height / 2;
				if (handle.y < 0)
					handle.y = 0;
				else if (handle.y > view.height - handle.height)
					handle.y = view.height - handle.height;
			}
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE));
		}
		
		private function mouseMoveListener(e:MouseEvent):void
		{
			if (_mode)
			{
				handle.x = view.mouseX - _offset;
				if (handle.x < 0)
					handle.x = 0;
				else if (handle.x > view.width - handle.width)
					handle.x = view.width - handle.width;
			}
			else
			{
				handle.y = view.mouseY - _offset;
				if (handle.y < 0)
					handle.y = 0;
				else if (handle.y > view.height - handle.height)
					handle.y = view.height - handle.height;
			}
			handle.setNeedDisplay();
			
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_UPDATE));
		}
		
	}
}