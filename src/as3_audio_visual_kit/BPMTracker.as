package as3_audio_visual_kit
{
	import as3_foundation.SubdivideExecutor;
	
	import org.si.utils.FFT;
	
	public class BPMTracker extends SubdivideExecutor
	{
		public const FFT_SIZE:Number = 1024;
		private static const FREQUENCIES:Vector.<Number> = new <Number>[0, 125, 250, 500, 1000, 2000, 6000, 11000];
		private static const SHIFT_SIZE:Number = 256;
		private static var SRATE:Number = 44100;
		
		private var _floorBPM:Number;
		private var _ceilBPM:Number;
		private var _time:Number = 0;
		
		private var _samples:Vector.<Number>;
		private var _peakDetectors:Vector.<PeakDetector>;
		private var _vectorizer:OnsetVectorizer;
		
		public function BPMTracker(samplingRate:Number, floorBPM:Number = 70, ceilBPM:Number = 185, numFrequencyBands:int = 7)
		{
			super(1, 1/10000000);
			SRATE = samplingRate;
			_floorBPM = floorBPM;
			_ceilBPM = ceilBPM;
			
			var agents:Vector.<Agent> = new Vector.<Agent>();
			var params:Vector.<StrategyParameter> = new Vector.<StrategyParameter>();
			for (i = 0; i < 3; i++) {
				var param:StrategyParameter = new StrategyParameter();
				param.floorBPM = floorBPM;
				param.ceilBPM = ceilBPM;
				// 自己相関期間を決める
				param.W = Math.ceil(7 / (SHIFT_SIZE / 44100));
				params.push(param);
			}
			
			params[0].watchFrequency = StrategyParameter.LOW_FREQUENCY;
			params[0].errorTolerance = 8;
			params[1].watchFrequency = StrategyParameter.MIDDLE_FREQUENCY;
			params[1].errorTolerance = 2;
			params[2].watchFrequency = StrategyParameter.ALL_FREQUENCY;
			params[2].errorTolerance = 1;
			agents.push(new Agent(SHIFT_SIZE, params[0]));
			agents.push(new Agent(SHIFT_SIZE, params[1]));
			agents.push(new Agent(SHIFT_SIZE, params[2]));
			_vectorizer = new OnsetVectorizer(numFrequencyBands, agents);
			
			_peakDetectors = new Vector.<PeakDetector>();
			
			for (var i:int = 0; i < numFrequencyBands; i++) {
				_peakDetectors.push(new PeakDetector(i, _vectorizer));
			}
		}
		
		override protected function execute(index:int):void {
			var fft:FFT = new FFT(FFT_SIZE);
			var res:Vector.<Number>;
			
			var samples:Vector.<Number> = _samples.slice(index * SHIFT_SIZE, index * SHIFT_SIZE + FFT_SIZE);
			
			if (samples.length < FFT_SIZE) return;
			
			fft.setData(samples);
			fft.calcFFT();
			res = fft.getMagnitude();
			var flg:Boolean = false;
			
			var l:int = _peakDetectors.length;
			var numMagnitudes:int = res.length;
			var s:int = FREQUENCIES[0];
			var e:int = s + Math.ceil((FREQUENCIES[1] - s) / 22050 * numMagnitudes);
			_peakDetectors[0].pushMagnitudes(res.slice(s, e));
			for (var i:int = 1; i < l; i++) {
				s = Math.ceil(FREQUENCIES[i] / 22050 * numMagnitudes);
				e = Math.ceil(FREQUENCIES[i + 1] / 22050 * numMagnitudes);
				_peakDetectors[i].pushMagnitudes(res.slice(s, e));
			}
			
			/*for (var ii:int = 0; ii < _vectorizer.onsetVectors.length; ii++) {
				var v:Number = 0;
				for (var jj:int = 0; jj < _vectorizer.onsetVectors[ii].length; jj++) {
					v += _vectorizer.onsetVectors[ii][jj];
				}
				trace(ii + " : " + v);
			}*/
			
			_time = SHIFT_SIZE / SRATE * index;
		}
		
		public function addSamples(samples:Vector.<Number>):void {
			_samples = samples;
			numDivides = _samples.length / SHIFT_SIZE;
		}
		
		public function get chosenAgent():Agent {
			var reliabilities:Vector.<Number> = new Vector.<Number>();
			var agents:Vector.<Agent> = _vectorizer.agents;
			
			// それぞれの周波数帯の Interpreter から BPM の候補と信頼度を得る
			for each (var agent:Agent in agents) {
				reliabilities.push(agent.reliability);
			}
			
			var i:int, l:int;
			
			// BPM の候補のなかで重複しているものがある場合、
			// 重複数をそれぞれの信頼度に掛ける
			/*var overlapped:Vector.<Vector.<int>> = getOverlappedIndices(bpms);
			for (i = 0, l = overlapped.length; i < l; i++) {
				var indices:Vector.<int> = overlapped[i];
				for (var j:int = 0, ll:int = indices.length; j < ll; j++) {
					reliabilities[indices[j]] *= indices.length; 
				}
			}*/
			
			// 候補中もっとも信頼度の高いものを選んで返す
			var maxIndex:int = 0;
			var maxReli:Number = 0;
			for (i = 0, l = reliabilities.length; i < l; i++) {
				if (maxReli < reliabilities[i]) {
					maxReli = reliabilities[i];
					maxIndex = i;
				}
			}

			return agents[maxIndex];
		}
		
		public function get agents():Vector.<Agent> {
			return _vectorizer.agents;
		}
		
		private function getOverlappedIndices(values:Vector.<Number>):Vector.<Vector.<int>> {
			var res:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			var tmp:Object = {};
			
			for (var i:int = 0, l:int = values.length; i < l; i++) {
				var value:Number = values[i];
				if (tmp[value] == undefined) tmp[value] = new Vector.<int>();
				tmp[value].push(i);
			}
			for (var k:String in tmp) {
				if (1 < tmp[k].length) {
					res.push(tmp[k]);
				}
			}
			return res;
		}
		
	}
}