package as3_audio_visual_kit
{
	import as3_foundation.math.Average;

	public class Tracker
	{
		private var _phase:int;
		private var _parameter:StrategyParameter;
		private var _reliability:Number = 0;
		private var _trackingBeatInterval:Number = 0;
		private var _trackingAverage:Average;
		
		private var _preBeatTime:Number = 0;
		private var _maxPower:Number = 0;
		
		private var _forecastFrame:int = 0;
		private var _forecastField:Vector.<Number>;
		
		public function Tracker(phase:int, beatInterval:int, param:StrategyParameter)
		{
			_phase = phase;
			_parameter = param;
			_trackingBeatInterval = beatInterval;
			
			_forecastFrame = _phase + beatInterval;
			_forecastField = new Vector.<Number>();
			_trackingAverage = new Average();
		}
		
		public function get reliability():Number
		{
			return _reliability;
		}

		public function get trackingBeatInterval():Number
		{
			return _trackingBeatInterval;
		}

		public function findOnset(now:int, power:Number):void {
			var errorTolerance:int = _parameter.errorTolerance;
			_maxPower = Math.max(_maxPower, power);
			//trace(now, _forecastFrame, power);
			// 予測場周辺のピークを保持する
			var rest:int = _forecastFrame + errorTolerance - now;
			
			if (rest <= errorTolerance * 2) {
				_forecastField[errorTolerance * 2 - rest] = power;
			}
			// 予測場が埋まったら
			if (rest == 0) {	
				var preForecast:int = _forecastFrame;
				
				// 予測場近傍の最も大きなピークを得る
				var maxInForecastField:Number = 0;
				var maxIndexInForecastField:int = 0;
				for (var ffIndex:int = 0, ffLength:int = _forecastField.length; ffIndex < ffLength; ffIndex++) {
					if (maxInForecastField < _forecastField[ffIndex]) {
						maxInForecastField = _forecastField[ffIndex];
						maxIndexInForecastField = ffIndex;
					}
				}
				
				var peakFrame:int = maxInForecastField == 0 ? _forecastFrame : _forecastFrame - (errorTolerance - maxIndexInForecastField);
				
				if (maxInForecastField < 0.1) {
					_preBeatTime = peakFrame;
					_forecastFrame = peakFrame + _trackingBeatInterval;
					_reliability *= 0.8;
				} else {
					var interval:int = peakFrame - _preBeatTime;
					_trackingAverage.addNumber(interval);
					_preBeatTime = peakFrame;
					_forecastFrame = peakFrame + _trackingBeatInterval;
					
					_reliability += maxInForecastField / _maxPower;
					//trace(_parameter.watchFrequencyString, "PEAK : " + peakFrame, " 予測 : " + preForecast, " 度合い : " + maxInForecastField / _maxPower, " 信頼度 : " + _reliability, "interval : " + _trackingBeatInterval, "実interval : " + interval, " 平均interval : " + _trackingAverage.getAverage(), " BPM : " + calcBPM(_trackingBeatInterval));
				}
			}
			
		}
		
		private function calcBPM(interval:Number):Number {
			if (interval == 0) return 0;
			var bpm:Number = 60 / (interval * 256 / 44100);
			while (bpm < _parameter.floorBPM) bpm *= 2;
			while (_parameter.ceilBPM < bpm) bpm *= 0.5;
			return bpm;
		}
		
	}
}