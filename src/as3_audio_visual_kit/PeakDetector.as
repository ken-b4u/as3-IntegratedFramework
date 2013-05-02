package as3_audio_visual_kit
{
	

	public class PeakDetector
	{
		private var _magnitudes:Vector.<Vector.<Number>>;
		
		private var _movingAverageWindow:Vector.<Number>;
		private var _movingAverageWindowSize:int;
		
		private var _preOnsetPower:Number = 0;
		
		private var _parameter:StrategyParameter;
		private var _vectorizer:OnsetVectorizer;
		
		private var _id:int = 0;
		
		public function PeakDetector(id:int, vectorizer:OnsetVectorizer)
		{
			_id = id;
			
			_vectorizer = vectorizer;
			
			_magnitudes = new Vector.<Vector.<Number>>();
			_movingAverageWindow = new Vector.<Number>();
			_movingAverageWindowSize = 3;
		}
		
		/**
		 * mags の length は一定を想定 
		 * @param mags 
		 */
		private var _hadOnset:Boolean = false;
		public function pushMagnitudes(mags:Vector.<Number>):void {
			_magnitudes.push(mags);
			
			if (4 <= _magnitudes.length) {
				var nowT:int = _magnitudes.length - 2;
				var d:Number, D:Number = 0,
					p:Number, pp:Number, np:Number,
					pm:Number, pl:Number, pr:Number, ppm:Number, nm:Number, nl:Number, nr:Number;
				
				for (var i:int = 1, l:int = mags.length - 1; i < l; i++) {
					p  = _magnitudes[nowT][i];
					ppm = _magnitudes[nowT - 2][i];
					var preMags:Vector.<Number> = _magnitudes[nowT - 1];
					pm = preMags[i];
					pl = preMags[i - 1];
					pr = preMags[i + 1];
					var nextMags:Vector.<Number> = _magnitudes[nowT + 1];
					nm = nextMags[i];
					nl = nextMags[i - 1];
					nr = nextMags[i + 1];
					
					pp = Math.max(Math.max(pm, Math.max(pr, pl)), ppm);
					np = Math.min(nm, Math.min(nl, nr));
					if (pp < p && pp < np) {
						d = p - pp + Math.max(0, nm - p);
						// 対象周波数帯の立ち上がり成分の総和
						D += d;
					}
				}
				
				_movingAverageWindow.push(D);
				
				if (_movingAverageWindowSize <= _movingAverageWindow.length) {
					
					var av:Number = 0;
					for (var j:int = 0; j < _movingAverageWindowSize; j++) {
						av += _movingAverageWindow[j];
					}
					av /= _movingAverageWindowSize;
					
					_movingAverageWindow.shift();
					
					if (_hadOnset && av < _preOnsetPower)
						_vectorizer.addOnset(_id, _magnitudes.length - 2, _preOnsetPower);
					else
						_vectorizer.addOnset(_id, _magnitudes.length - 2, 0);
					
					_hadOnset = _preOnsetPower < av;
					_preOnsetPower = av;
				} else _vectorizer.addOnset(_id, _magnitudes.length - 2, 0);
			}
		}
		
	}
}