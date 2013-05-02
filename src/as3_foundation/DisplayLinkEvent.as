package as3_foundation
{
	import flash.events.Event;

	public class DisplayLinkEvent extends Event
	{
		public static const DISPLAY_UPDATE:String = "displayUpdate";
		
		public function DisplayLinkEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new DisplayLinkEvent(type, bubbles, cancelable);
		}
	}
}