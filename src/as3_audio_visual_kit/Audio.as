package as3_audio_visual_kit
{
	import as3_animation_kit.Animator;
	import as3_animation_kit.IEasing;
	
	import as3_foundation.Performer;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class Audio extends Sound implements IAudioSource
	{
		private var _channel:SoundChannel;
		private var _tsfm:SoundTransform;
		private var _comp:Function;
		private var _isPlaying:Boolean = false;
		private var _exclusive:Boolean = true;
		private var _positionMem:Number = 0;
		private var _loaded:Boolean = false;
		
		public function Audio(stream:URLRequest=null, context:SoundLoaderContext=null)
		{
			super(stream, context);
			_tsfm = new SoundTransform();
		}
		
		override public function play(startTime:Number=0, loops:int=0, sndTransform:SoundTransform=null):SoundChannel
		{
			if (_exclusive && _isPlaying) return null;
			
			_channel = super.play(startTime, loops, sndTransform);
			if (_channel) {
				_channel.soundTransform = sndTransform || _tsfm;
                if (sndTransform) {
                    _tsfm.volume = sndTransform.volume;
                    _tsfm.pan = sndTransform.pan;
                }
				_channel.addEventListener(Event.SOUND_COMPLETE, soundComp);
			}
			_isPlaying = true;
			return _channel;
		}
		
		override public function load(stream:URLRequest, context:SoundLoaderContext=null):void {
			super.load(stream, context);
			addEventListener(Event.COMPLETE, loadedSound);
			addEventListener(IOErrorEvent.IO_ERROR, ioerror);
		}
		
		public function pause():void {
			if (_channel) {
				_positionMem = _channel.position;
				_channel.stop();
			}
			_isPlaying = false;
		}
		
		public function resume():void {
			this.play(_positionMem);
			_isPlaying = true;
		}
		
		public function stop():void {
			if (_channel) _channel.stop();
			_isPlaying = false;
		}
		
		public function get time():Number {
			return _channel.position;
		}
		public function set time(time:Number):void {
			stop();
			play(time);
		}
		
		public function playWithCallback(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null, comp:Function = null):SoundChannel
		{
			if (_exclusive && _isPlaying) return null;
			
			_channel = super.play(startTime, loops, sndTransform);
			if (_channel) {
                _channel.soundTransform = sndTransform || _tsfm;
                if (sndTransform) {
                    _tsfm.volume = sndTransform.volume;
                    _tsfm.pan = sndTransform.pan;
                }
				_channel.addEventListener(Event.SOUND_COMPLETE, soundComp);
			}
			
			_comp = comp;
			_isPlaying = true;
			return _channel;
		}
		
		protected function soundComp(event:Event):void
		{
			if (_comp != null) _comp.call();
			removeEventListener(Event.SOUND_COMPLETE, soundComp);
			_isPlaying = false;
		}
		
		public function fadeIn(volume:Number, step:int, easing:IEasing, delay:Number = 0):void
		{
			if (_channel == null) return;
			
			_tsfm.volume = 0;
			var anim:Animator = new Animator();
			_channel.soundTransform = _tsfm;
			anim.tween(_tsfm, "volume", volume, step, easing, delay);
			anim.update(new Performer(this, function():void{
				_channel.soundTransform = _tsfm;
			}));
		}
		
		public function fadeOut(volume:Number, step:int, easing:IEasing):void
		{
			var anim:Animator = new Animator();
			anim.tween(_tsfm, "volume", volume, step, easing);
			anim.update(new Performer(this, function():void{
				_channel.soundTransform = _tsfm;
			}));
            anim.complete(new Performer(this, function():void {
                _channel.stop();
            }));
		}
		
		public function set volume(vol:Number):void {
			_tsfm.volume = vol;
			if (_channel)
				_channel.soundTransform = _tsfm;
		}
		
		public function get volume():Number {
			return _tsfm.volume;
		}
		
		public function get exclusive():Boolean
		{ 
			return _exclusive; 
		}
		
		public function set exclusive(value:Boolean):void
		{
			if (value !== _exclusive)
			{
				_exclusive = value;
			}
		}

		private function loadedSound(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, loadedSound);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
			_loaded = true;
		}
		
		private function ioerror(e:IOErrorEvent):void {
			e.target.removeEventListener(Event.COMPLETE, loadedSound);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
			dispatchEvent(e);
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}

		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
	}
}