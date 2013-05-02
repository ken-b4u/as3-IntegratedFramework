package as3_audio_visual_kit
{
	
	public class Agent
	{
		private static const START_TRACKING_THRESHOLD:int = 5;
		
		private var _vectroizer:OnsetVectorizer;
		
		private var _timeIntervalFrames:int;
		private var _parameter:StrategyParameter;
		private var _watchAt:int;
		private var _watchLength:int;
		
		private var _intervalHistory:Vector.<Number> = new Vector.<Number>();
		private var _phase:int = 0 ;
		
		private var _doTrack:Boolean = false;
		
		private var _excludedIntervals:Vector.<Number>;
		
		private var _reduce:int = 0;
		private var _walk:int = 0;
		
		private var _beatTracker:Tracker;
		private var _backBeatTracker:Tracker;
		
		public function Agent(timeIntervalFrames:int,  param:StrategyParameter)
		{
			_timeIntervalFrames = timeIntervalFrames;
			_parameter = param;
			
			_excludedIntervals = new Vector.<Number>();
			
			_reduce = 1 / (_timeIntervalFrames / 44100);
			
			_beatTracker = new Tracker(0, 0, _parameter);
			_backBeatTracker = new Tracker(0, 0, _parameter);
		}
		
		public function updateOnsetVector():void {
			var now:int = _vectroizer.onsetVectors.length - 1;
			var errorTolerance:int = _parameter.errorTolerance;
			var power:Number;
			
			/*power = getPower(_vectroizer.onsetVectors[now]);
			var col:uint = 0;
			var xx:Number = now / 10;
			var c:Sprite = BeatDetection.canvas;
			c.graphics.lineStyle(1, 0);
			c.graphics.lineTo(xx, c.stage.stageHeight * 0.5 - power);*/
			
			if (_doTrack) {
				power = getPower(_vectroizer.onsetVectors[now]);
				_beatTracker.findOnset(now, power);
				_backBeatTracker.findOnset(now, power);
			} else if (_reduce <= ++_walk) {
				// 追跡フラグがまだ立っていなかったら自己相関関数から相関値の高い tau を見つけ、
				// ヒストリに追加する。
				// ヒストリ中の最頻値の出現数がしきい値を超えたら追跡フラグをたてる.
				var chosenTau:int = autoCorrelation();
				if (0 < chosenTau) {
					_intervalHistory.push(chosenTau);	
					var mode:Vector.<Number> = getModeValueWithCount(_intervalHistory);
					_phase = -1;
					//trace(_parameter.watchFrequencyString,mode);
					if (START_TRACKING_THRESHOLD < mode[1]) 
						_phase = getPhase();
					
					if (0 <= _phase) {
						var interval:int = mode[0];
						_beatTracker = new Tracker(_phase, interval, _parameter);
						_excludedIntervals.push(interval - 1);
						_excludedIntervals.push(interval);
						_excludedIntervals.push(interval + 1);
						_backBeatTracker = new Tracker(_phase - Math.floor(interval * 0.5), interval, _parameter);
						
						_doTrack = true;
						
						var phase:int = Math.max(_phase - errorTolerance, 0);
						for (phase; phase <= now; phase++) {
							power = getPower(_vectroizer.onsetVectors[phase]);
							_beatTracker.findOnset(phase, power);
							_backBeatTracker.findOnset(phase, power);
						}
						
					}
				}
				_walk = 0;
			}
		}
		
		private function getPower(vec:Vector.<Number>):Number {
			var i:int = _watchAt;
			var l:int = _watchLength;
			var p:Number = 0;
			for (i; i < l; i++) {
				p += vec[i];
			}
			return p;
		}
		
		private var _expander:Number = 1;
		public function autoCorrelation():int {
			var W:int = _parameter.W;
			
			var numerator:Number, denominator:Number = 0;
			var validMin:int = Math.floor(60 / (_parameter.ceilBPM) * 44100 / _timeIntervalFrames);
			var validMax:Number = Math.ceil(60 / (_parameter.floorBPM * _expander) * 44100 / _timeIntervalFrames);
			var onsetVectors:Vector.<Vector.<Number>> = _vectroizer.onsetVectors;
			var c:int = onsetVectors.length;
			if (c < W + validMax) return 0;
			
			var denominators:Vector.<Number> = new Vector.<Number>();
			var winResults:Vector.<Number> = new Vector.<Number>();
			
			var isFirst:Boolean = true;
			var firstT:int = c - W;
			
			var maxR:Number = 0;
			var chosenTau:Number = 0;
			denominator = 0;
			
			for (var tau:int = validMin; tau < validMax; tau++) {
				numerator = 0;
				for (var t:int = firstT; t < c; t++) {
					var vec:Vector.<Number> = onsetVectors[t];
					var oldVec:Vector.<Number> = onsetVectors[t - tau];
					var vecIsZero:Boolean = _vectroizer.isZeroFlags[t];
					var oldVecIsZero:Boolean = _vectroizer.isZeroFlags[t - tau];
					var win:Number;
					
					if (isFirst) {
						win = window(c - t, W);
						winResults.push(win);
						if (!vecIsZero) denominator += dot(vec, vec) * win;
					} else {
						var idx:int = t - firstT;
						win = winResults[idx];
					}
					if (!oldVecIsZero) numerator += dot(vec, oldVec) * win;
				}
				isFirst = false;
				var r:Number = numerator / denominator;
				if (maxR < r) {
					maxR = r;
					chosenTau = tau;
				}
			}
			
			if (maxR < 0.1) _expander = 1 / 4;
			return chosenTau;
			
			return 0;
		}
		
		private function window(t:Number, W:int):Number {
			return 1 - 0.5 * t / W;
		}
		
		private function dot(vec:Vector.<Number>, vec2:Vector.<Number>):Number {
			var d:Number = 0;
			var i:int = _watchAt;
			var l:int = _watchLength;
			for (i; i < l; i++) {
				d += vec[i] * vec2[i];
			}
			return d;
		}
		
		private function getModeValue(vec:Vector.<Number>):int {
			var counter:Array = [];
			var m:int = 0;
			var mode:Number = 0;
			
			for (var i:int = 0, l:int = vec.length; i < l; i++) {
				var v:Number = vec[i];
				
				if (isNaN(counter[v])) counter[v] = 0;
				counter[v]++;
				
				if (m < counter[v]) {
					m = counter[v];
					mode = v;
				}
			}
			return mode;
		}
		
		private function getModeValueWithCount(vec:Vector.<Number>):Vector.<Number> {
			var counter:Array = [];
			var m:int = 0;
			var mode:Number = 0;
			
			for (var i:int = 0, l:int = vec.length; i < l; i++) {
				var v:Number = vec[i];
				var excluded:Boolean = false;
				for each (var exclude:Number in _excludedIntervals) {
					if (v == exclude) {
						excluded = true;
						break;
					}
				}
				if (!excluded) {
					if (isNaN(counter[v])) counter[v] = 0;
					counter[v]++;
					
					if (m < counter[v]) {
						m = counter[v];
						mode = v;
					}
				}
			}
			return new <Number>[mode, counter[mode]];
		}
		
		private function getPhase():int {
			var onsetVectors:Vector.<Vector.<Number>> = _vectroizer.onsetVectors;
			var allPeaks:Vector.<Number> = new Vector.<Number>();
			var maxPeak:Number = 0;
			var stride:int = getModeValueWithCount(_intervalHistory)[0];
			var w:int = Math.ceil(5 / (_timeIntervalFrames / 44100));
			var i:int = 0, l:int = onsetVectors.length;
			var size:int = 30;
			if (w * 2 + size < onsetVectors.length) {
				for (i; i < l; i++) {
					var v:Number = 0;
					var vec:Vector.<Number> = onsetVectors[i];
					for (var j:int = _watchAt, jl:int = _watchLength; j < jl; j++) {
						v += vec[j];
					}
					allPeaks.push(v);
					if (maxPeak < v) maxPeak = v;
				}
				
				var beats:Vector.<Number> = new Vector.<Number>();
				for (i = 0; i < w; i++) {
					if (i % stride == 0) beats.push(maxPeak);
					else beats.push(0);
				}
				var maxR:Number = 0;
				var maxRIdx:int = 0;
				for (var tau:int = 0; tau < w; tau++) {
					var r:Number = 0;
					for (i = 0; i < w; i++) {
						r += allPeaks[i + tau] * beats[i]; 
					}
					if (maxR < r) {
						maxR = r;
						maxRIdx = tau
					}
				}
				
				if (maxR == 0) return -1;
				// fit
				var m:Number = 0;
				var mi:int = 0;
				for (i = Math.max(maxRIdx - size, 0), l = maxRIdx + size; i < l; i++) {
					if (m < allPeaks[i]) {
						m = allPeaks[i];
						mi = i;
					}
				}
				return mi;
				return maxRIdx;
			}
			return -1;
		}
		
		private function calcBPM(interval:Number):Number {
			if (interval == 0) return 0;
			var bpm:Number = 60 / (interval * _timeIntervalFrames / 44100);
			while (bpm < _parameter.floorBPM) bpm *= 2;
			while (_parameter.ceilBPM < bpm) bpm *= 0.5;
			return bpm;
		}
		
		public function get reliability():Number
		{
			return Math.max(_beatTracker.reliability, _backBeatTracker.reliability);
		}
		
		public function get phase():int
		{
			return _phase;
		}
		
		public function get vectroizer():OnsetVectorizer
		{
			return _vectroizer;
		}
		
		public function set vectroizer(value:OnsetVectorizer):void
		{
			_vectroizer = value;
			var wf:int = _parameter.watchFrequency;
			if (wf == StrategyParameter.LOW_FREQUENCY) {
				_watchAt = 0;
				_watchLength = 2;
			} else if (wf == StrategyParameter.MIDDLE_FREQUENCY) {
				_watchAt = 2;
				_watchLength = 5;
			} else if (wf == StrategyParameter.HIGH_FREQUENCY) {
				_watchAt = 5;
				_watchLength = _vectroizer.dimension;
			} else if (wf == StrategyParameter.ALL_FREQUENCY) {
				_watchAt = 0;
				_watchLength = _vectroizer.dimension;
			}
		}
		
		public function get BPM():Number
		{
			trace("-- " + _parameter.watchFrequencyString + " --");
			trace(calcBPM(_beatTracker.trackingBeatInterval), _beatTracker.reliability);
			trace(calcBPM(_backBeatTracker.trackingBeatInterval), _backBeatTracker.reliability);
			return calcBPM(_beatTracker.trackingBeatInterval);
		}
		
	}
}