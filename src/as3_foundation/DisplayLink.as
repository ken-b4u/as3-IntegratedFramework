package as3_foundation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class DisplayLink extends EventDispatcher
	{
		private static var _instance:DisplayLink;
		private var _updateEvent:DisplayLinkEvent;
		private var _dispatcher:Sprite;
		
		public function DisplayLink()
		{
			if (_instance) {
				throw new Error("DisplayLink class is singleton class.");
				return;
			}
			_updateEvent = new DisplayLinkEvent(DisplayLinkEvent.DISPLAY_UPDATE);
			_dispatcher = new Sprite();
		}
		
		public static function get instance():DisplayLink {
			if (_instance == null) _instance = new DisplayLink();
			return _instance;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (!hasEventListener(DisplayLinkEvent.DISPLAY_UPDATE)) {
				_dispatcher.addEventListener(Event.ENTER_FRAME, enterframe);
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			super.removeEventListener(type, listener, useCapture);
			if (!hasEventListener(DisplayLinkEvent.DISPLAY_UPDATE)) {
				_dispatcher.removeEventListener(Event.ENTER_FRAME, enterframe);
			}
		}
		
		private function enterframe(e:Event):void {
			dispatchEvent(_updateEvent);
		}
	}
}