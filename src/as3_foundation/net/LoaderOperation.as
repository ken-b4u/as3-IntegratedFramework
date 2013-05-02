package as3_foundation.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import as3_foundation.Operation;
	
	
	public class LoaderOperation extends Operation
	{
		private var _req:URLRequest;
		private var _loader:Loader;
		private var _checkPolicyFile:Boolean;
		
		public function LoaderOperation(req:URLRequest, checkPolicyFile:Boolean = false)
		{
			super();
			
			_req = req;
			_loader = new Loader();
			_checkPolicyFile = checkPolicyFile;
			
			if (_req) imReady();
		}
		
		public function set request(req:URLRequest):void
		{
			_req = req;
			imReady();
		}
		
		override protected function main():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			_loader.load(_req, (_checkPolicyFile ? (new LoaderContext(true)) : null));
		}
		
		override public function get progress():Number
		{
			if (_loader) {
				if (_loader.contentLoaderInfo.bytesTotal == 0) return 0;
				else return _loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal;
			}
			return 0;
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		override public function cancel():void
		{
			super.cancel();
			_loader.close();
			_loader.unload();
		}
		
		private function complete(e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
			var bmp:Bitmap = _loader.content as Bitmap;
			if (bmp) bmp.smoothing = true;
			imFinished();
			dispatchEvent(e);
		}
		
		private function ioerror(e:IOErrorEvent):void {
			//trace(e);
		}
	}
}