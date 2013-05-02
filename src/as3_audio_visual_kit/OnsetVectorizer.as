package as3_audio_visual_kit
{
	public class OnsetVectorizer
	{
		private var _onsetVectors:Vector.<Vector.<Number>>;
		private var _isZeroFlags:Vector.<Boolean>;
		private var _dimension:int;
		private var _agents:Vector.<Agent>;
		
		public function OnsetVectorizer(dimension:int, agents:Vector.<Agent>)
		{
			_dimension = dimension;
			_agents = agents;
			_onsetVectors = new Vector.<Vector.<Number>>();
			_isZeroFlags = new Vector.<Boolean>();
			
			for each (var agent:Agent in agents) {
				agent.vectroizer = this;
			}
		}

		public function addOnset(id:int, frame:int, onsetDegree:Number):void {
			while (_onsetVectors.length - 1 < frame) {
				var vec:Vector.<Number> = new Vector.<Number>();
				for (var i:int = 0; i < _dimension; i++) {
					vec.push(0);
				}
				_onsetVectors.push(vec);
				_isZeroFlags.push(true);
			}
			if (onsetDegree != 0) _isZeroFlags[frame] = false;
			_onsetVectors[frame][id] = onsetDegree;
			
			if (id == _dimension - 1) {
				for each (var agent:Agent in _agents) {
					agent.updateOnsetVector();
				}
				//_agents[2].updateOnsetVector();
			}
		}
		
		public function get agents():Vector.<Agent>
		{
			return _agents;
		}
		
		public function get isZeroFlags():Vector.<Boolean>
		{
			return _isZeroFlags;
		}
		
		public function get onsetVectors():Vector.<Vector.<Number>>
		{
			return _onsetVectors;
		}
		
		public function get dimension():int
		{
			return _dimension;
		}
		
	}
}