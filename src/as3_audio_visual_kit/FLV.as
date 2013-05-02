package as3_audio_visual_kit
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import as3_foundation.log.Logger;
	import as3_foundation.log.ObjectParser;
	
	public class FLV extends Sprite implements IAudioSource
	{
		private var _url:String;
		private var _hasMetaData:Boolean = false;
		
		private var _video:Video;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _playing:Boolean = false;
		private var _loaded:Boolean;
		
		private var _duration:Number = 0;
		private var _sourceWidth:Number = 0;
		private var _sourceHeight:Number = 0;
		private var _codec:int = -1;
		private var _frameRate:int = 24;
		private var _cuePoints:Vector.<CuePoint>;
		
		private var _volume:Number = 1;
		private var _loadStatusCheckTimer:Timer;
		private var _arrivalEnd:Boolean = false;
		
		private var _seeking:Boolean = false;
		
		public function FLV(url:String = "")
		{
			super();
			_url = url;
		}
		
		public function load(url:String = ""):void {
			if (_loaded && (url == "" || _url == url)) return;

			if (url.length) _url = url;
			
			_loaded = false;
			_nc = new NetConnection();
			_nc.connect(null);
			_ns = new NetStream(_nc);
			_ns.client = {
				onTimeCoordInfo:onTimeCoordInfo,
				onMetaData:onMetaData,
				onXMPData:onXMPData,
				onBWDone:onBWDone,
				onPlayStatus:onPlayStatus,
				onCuePoint: onCuePoint
			};
			_ns.addEventListener(NetStatusEvent.NET_STATUS, streamStatus);
			_ns.play(_url);
			
			_video = new Video();
			_video.attachNetStream(_ns);
			_video.smoothing = true;
			addChild(_video);
			
			_cuePoints = new Vector.<CuePoint>();
			
			if (_loadStatusCheckTimer) {
				_loadStatusCheckTimer.stop();
				_loadStatusCheckTimer.reset();
			}
			else _loadStatusCheckTimer = new Timer(100);
			_loadStatusCheckTimer.addEventListener(TimerEvent.TIMER, checkLoadProgress);
			_loadStatusCheckTimer.start();
		}
		
		private function checkLoadProgress(e:TimerEvent):void {
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _ns.bytesLoaded, _ns.bytesTotal));
			if (_ns.bytesLoaded == _ns.bytesTotal) {
				_video.width = _sourceWidth;
				_video.height = _sourceHeight;
				
				var st:SoundTransform = _ns.soundTransform;
				st.volume = _volume;
				_ns.soundTransform = st;
				
				_loadStatusCheckTimer.removeEventListener(TimerEvent.TIMER, checkLoadProgress);
				_loadStatusCheckTimer = null;
				_loaded = true;
				
				if (_hasMetaData) {
					if (!_playing) {
						_ns.pause();
						_ns.seek(0);
					}
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		private function onMetaData(info:Object):void {
			// if onMetaData had been called once
			if (_sourceWidth) return;
			
			for (var i:String in info) {
				//Logger.instance().info("onMetaData - " + i + " : " + info[i]);
				if (i == "duration") _duration = info[i];
				else if (i == "width") _sourceWidth = info[i] as Number;
				else if (i == "height") _sourceHeight = info[i] as Number;
				else if (i == "videocodecid") _codec = info[i] as int;
				else if (i == "framerate") _frameRate = info[i] as int;
				else if (i == "cuePoints") {
					for (var j:int = 0, l:int = info[i].length; j < l; j++) {
						var o:Object = info[i][j];
						
						var cue:CuePoint = new CuePoint(o.name, o.time);
						_cuePoints.push(cue);
					}
				}
			}
			_video.width = _sourceWidth;
			_video.height = _sourceHeight;

			var st:SoundTransform = _ns.soundTransform;
			st.volume = _volume;
			_ns.soundTransform = st;
			_hasMetaData = true;
			
			if (_loaded) {
				if (!_playing) {
					_ns.pause();
					_ns.seek(0);
				}
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onXMPData(info:Object):void {
			/*for (var ii:String in info) {
				Logger.instance().info("onXMPData - "+ii+" : "+info[ii]);
			}*/
			if (info.data && _cuePoints.length == 0) {
				var data:String = String(info.data).replace(/\n/g, "").replace(/\r/g, "").replace(/\r\n/g, "");
				var fpsParse:Array = data.match(/frameRate="f([0-9]*?)"/);
				_frameRate = fpsParse[1];
				var cuePoints:Array = data.match(/(<rdf:Description\s*?xmpDM:startTime.*?<\/rdf:Description>)/g)
				for (var i:int = 0; i < cuePoints.length; i++) {
					var xmlst:String = cuePoints[i].replace(/:/g, "");
					var xml:XML = new XML(xmlst);
					var name:String = xml.@xmpDMname;
					if (name.length) {
						
						_cuePoints.push(new CuePoint(name, (1 / _frameRate) * xml.@xmpDMstartTime));
					}
				}
			}
		}
		
		private function streamStatus(e:NetStatusEvent):void {
			/*for (var i:String in e.info) {
				Logger.instance().info("streamStatus - " + i + " : " + e.info[i]);
			}*/
			//trace(e.info.code);
			if (e.info.level == "error") {
				
				if (e.info.code == "NetStream.Play.StreamNotFound") {
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Stream not found " + _url));
				} else if (e.info.code == "NetStream.Seek.Failed") {
					dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Stream not found " + _url));
					//dispatchEvent(new FLVEvent(FLVEvent.SEEK_FAILED, true));
					_seeking = false;
				} else {
					Logger.instance().error(ObjectParser.parse(e.info), this, this.duration);
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, false, e.info.code));
				}
			}
			else if (e.info.code == "NetStream.Seek.Notify") {
				if (_seeking) dispatchEvent(new FLVEvent(FLVEvent.SEEK_NOTIFY, true));
				_seeking = false;
			}
			else if (e.info.code == "NetStream.Seek.Complete") {
				if (_seeking) dispatchEvent(new FLVEvent(FLVEvent.SEEK_COMPLETE, true));
				_seeking = false;
			}
			else if (e.info.code == "NetStream.Play.Stop") {
				_arrivalEnd = true;
				_playing = false;
				dispatchEvent(new FLVEvent(FLVEvent.ARRIVAL_END, true));
			}

		}
		
		private function onPlayStatus(info:Object):void {
			/*for (var i:String in info) {
				Logger.instance().info("onPlayStatus - " + i + " : " + info[i]);
			}
			if (info.code == "NetStream.Play.Complete") {
				dispatchEvent(new FLVEvent(FLVEvent.ARRIVAL_END, true));
			}*/
		}
		
		public function play():void {
			_ns.seek(0);
			_ns.resume();
			_playing = true;
			_arrivalEnd = false;
			dispatchEvent(new FLVEvent(FLVEvent.RESUME, true));
		}
		
		public function resume():void {
			_ns.resume();
			_playing = true;
			dispatchEvent(new FLVEvent(FLVEvent.RESUME, true));
		}
		
		public function pause():void {
			_ns.pause();
			_playing = false;
			dispatchEvent(new FLVEvent(FLVEvent.PAUSE, true));
		}
		
		public function stop():void {
			_ns.pause();
			_ns.seek(0);
			_playing = false;
			_arrivalEnd = false;
			dispatchEvent(new FLVEvent(FLVEvent.PAUSE, true));
		}
		
		public function seek(time:Number):void {
			_ns.seek(time);
			_seeking = true;
		}
		
		public function get time():Number {
			return _ns.time;
		}
		
		public function dispose():void {
			if (_loadStatusCheckTimer) {
				_loadStatusCheckTimer.removeEventListener(TimerEvent.TIMER, checkLoadProgress);
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, streamStatus);
			}
			_ns.close();
			_nc.close();
		}
		
		private function onBWDone():void {
			Logger.instance().info("onBWDone");
		}
		
		private function onTimeCoordInfo(info:Object = null):void {
			/*for (var i:String in info) {
				Logger.instance().info("onTimeCoordInfo - "+i+" : "+info[i]);
			}*/
		}
		
		private function onCuePoint(info:Object = null):void {
			/*for (var i:String in info) {
				Logger.instance().info("onCuePoint - "+i+" : "+info[i]);
			}*/
			if (_playing == false) return;
			
			for each (var cue:CuePoint in _cuePoints) {
				//trace(cue.name, info.name, cue.time, info.time);
				
				if (cue.name == info.name && Math.abs(cue.time - info.time) < 0.1) {
					/*var cnt:int = 0;
					addEventListener(Event.EXIT_FRAME, function():void {
						if (cnt++ == 1) {
							dispatchEvent(new FLVEvent(FLVEvent.ON_CUE_POINT, true, false, cue));
							removeEventListener(Event.EXIT_FRAME, arguments.callee);
						}
					});
					return;*/
					dispatchEvent(new FLVEvent(FLVEvent.ON_CUE_POINT, true, false, cue));
					removeEventListener(Event.EXIT_FRAME, arguments.callee);
				}
			}
		}

		public function get duration():Number
		{
			return _duration;
		}

		public function get codec():int
		{
			return _codec;
		}

		public function get frameRate():int
		{
			return _frameRate;
		}

		public function get cuePoints():Vector.<CuePoint>
		{
			return _cuePoints;
		}

		public function get volume():Number {
			return _volume;
		}
		
		public function set volume(v:Number):void {
			_volume = v;
			if (_ns) _ns.soundTransform = new SoundTransform(v);
		}
		
		public function get isLoaded():Boolean {
			if (_ns) return _loaded;
			return false; 
		}
		
		override public function toString():String {
			return "FLV : url = " + _url;
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function get arrivalEnd():Boolean
		{
			return _arrivalEnd;
		}


	}
}