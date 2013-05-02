package as3_audio_visual_kit
{
	public class CuePoint
	{
		private var _name:String;
		private var _time:Number;
		
		public function CuePoint(name:String, time:Number)
		{
			_name = name;
			_time = time;
		}
		
		public function get time():Number
		{
			return _time;
		}

		public function get name():String
		{
			return _name;
		}
		
		public function toString():String {
			return "-- Cue Point --\nname : " + _name + "\ntime : " + _time;
		}

	}
}