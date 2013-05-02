package as3_audio_visual_kit
{
	import flash.events.Event;
	
	public class FLVEvent extends Event
	{
		public static const ON_CUE_POINT:String = "onCuePoint";
		public static const ARRIVAL_END:String = "arrivalEnd";
		public static const SEEK_COMPLETE:String = "seekComplete";
		public static const SEEK_NOTIFY:String = "seekComplete";
		public static const SEEK_FAILED:String = "seekFailed";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		
		public var cuePoint:CuePoint;
		
		public function FLVEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, cuePoint:CuePoint = null)
		{
			super(type, bubbles, cancelable);
			this.cuePoint = cuePoint;
		}
		
		override public function clone():Event {
			return new FLVEvent(type, bubbles, cancelable, cuePoint);
		}
		
	}
}