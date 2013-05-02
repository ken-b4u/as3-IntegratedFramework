package as3_audio_visual_kit
{
	public class MultiChannelMixer implements IAudioSource
	{
		private var _volume:Number = 1;
		private var _inputs:Vector.<IAudioSource>;
		private var _numInputs:int;
		
		public function MultiChannelMixer(numInputs:int = 2)
		{
			_numInputs = numInputs;
			_inputs = new Vector.<IAudioSource>();
			for (var i:int = 0; i < numInputs; i++) {
				_inputs.push(null);
			}
		}
		
		public function input(src:IAudioSource, ch:int):void {
			if (ch < _inputs.length && _inputs[ch]) _inputs[ch].volume /= _volume;
			_inputs[ch] = src;
			src.volume *= _volume;
		}
		
		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			for each(var a:IAudioSource in _inputs) {
				a.volume = value;
			}
			_volume = value;
		}

		public function getInput(ch:int):IAudioSource {
			return _inputs[ch];
		}

		public function get numInputs():int
		{
			return _inputs.length;
		}

	}
}