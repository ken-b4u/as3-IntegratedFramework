package as3_audio_visual_kit
{
	
	import as3_foundation.Operation;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class AudioLoaderOperation extends Operation
	{
		private var _req:URLRequest;
		private var _audio:Audio;
		
		public function AudioLoaderOperation(req:URLRequest)
		{
			super();
			
			_req = req;
			if (_req) imReady();
		}
		
		override protected function main():void
		{
			_audio = new Audio();
			_audio.addEventListener(Event.COMPLETE, complete);
			_audio.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			_audio.load(_req);
		}
		
//		override public function get process():Number
//		{
//			if (_audio) {
//				if (_audio.bytesTotal == 0) return 0;
//				else return _audio.bytesLoaded / _audio.bytesTotal;
//			}
//			return 0; 
//		}
		
		public function get audio():Audio
		{
			return _audio;
		}
		
		override public function cancel():void
		{
			super.cancel();
			_audio.close();
		}
		
		private function complete(e:Event):void
		{
			_audio.removeEventListener(Event.COMPLETE, complete);
			imFinished();
			dispatchEvent(e);
		}
		
		private function ioerror(e:IOErrorEvent):void {
			trace(this, _req.url, e);
		}
		
	}
}