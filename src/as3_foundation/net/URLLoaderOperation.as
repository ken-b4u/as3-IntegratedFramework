package as3_foundation.net
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import as3_foundation.Operation;


	public class URLLoaderOperation extends Operation
	{
		private var _req:URLRequest;
		private var _urlLoader:URLLoader;
		
		public function URLLoaderOperation(req:URLRequest)
		{
			super();

			_req = req;
			if (_req)
				imReady();
		}

		public function get request():URLRequest
		{
			return _req;
		}
		
		public function set request(req:URLRequest):void
		{
			_req = req;
			imReady();
		}

		override protected function main():void
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, loaded);
			_urlLoader.load(_req);
		}
		
		public function get urlLoader():URLLoader
		{
			return _urlLoader;
		}

		private function loaded(e:Event):void
		{
			(e.currentTarget as URLLoader).removeEventListener(Event.COMPLETE, loaded);
			imFinished();
			dispatchEvent(e);
		}
	}
}