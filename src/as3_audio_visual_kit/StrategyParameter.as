package as3_audio_visual_kit
{
	public class StrategyParameter
	{
		public static const LOW_FREQUENCY:int = 0;
		public static const MIDDLE_FREQUENCY:int = 1;
		public static const HIGH_FREQUENCY:int = 2;
		public static const ALL_FREQUENCY:int = 3;
		
		// BPM検出範囲
		public var floorBPM:Number;
		public var ceilBPM:Number;
		
		// 注目周波数帯
		public var watchFrequency:int;
		
		// 自己相関期間
		public var W:int;
		
		// 前後の誤差許容フレーム数
		public var errorTolerance:int = 0;
		
		public function StrategyParameter()
		{
		}
		
		public function get watchFrequencyString():String {
			if (watchFrequency == LOW_FREQUENCY) return "LOW";
			else if (watchFrequency == MIDDLE_FREQUENCY) return "MIDDLE";
			else if (watchFrequency == HIGH_FREQUENCY) return "HIGH";
			else return "ALL";
		}
	}
}