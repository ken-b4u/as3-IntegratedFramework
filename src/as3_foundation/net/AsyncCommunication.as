package as3_foundation.net {
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	import as3_foundation.log.Logger;
	
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ProgressEvent", name="PROGRESS")]
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	
	public class AsyncCommunication extends EventDispatcher {
		private var _method:String;
		private var _params:String;
		private var _data:String;
		private var _isExecuting:Boolean = false;
		private var _urlLoader:URLLoader;

		public function AsyncCommunication() {
			
		}

		public function execute(base:String, method:String, params:Object = null, requestMethod:String = "GET", isMultipart:Boolean = false):void
		{
			_isExecuting = true;
			_method = method;
			var variables:URLVariables;
			var request:URLRequest = new URLRequest(base + method);
			request.method = requestMethod;
			
			if (!isMultipart) {
				_params = "";
				if (requestMethod == URLRequestMethod.GET) {
					_params = HTTPParameter.getGetParameters(params);
					request.url += _params;
				}
				else if (requestMethod == URLRequestMethod.POST) {	
					request.data = HTTPParameter.getPostParameters(params);
				}
			} else {
				var boundary:String = (0xffffffff * Math.random()).toString(16);
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes("--" + boundary + "\r\n");
				for (var key:String in params) {
					ba.writeUTFBytes('Content-Disposition: form-data; name="' + key + '"');
					var data:* = params[key];
					if (data is ByteArray) {
						ba.writeUTFBytes('; filename="' + key + '"');
						ba.writeUTFBytes("\r\n");
						ba.writeUTFBytes("Content-Type: image/jpeg");
						ba.writeUTFBytes("\r\n\r\n");
						ba.writeBytes(data);
					} else {
						ba.writeUTFBytes("\r\n\r\n");
						ba.writeUTFBytes(data);
					}
					ba.writeUTFBytes("\r\n");
					ba.writeUTFBytes("--" + boundary + "\r\n");
				}
				request.data = ba;
				request.contentType = "multipart/form-data, boundary=" + boundary;
			}
			_urlLoader = new URLLoader();
			if (isMultipart) _urlLoader.addEventListener(ProgressEvent.PROGRESS, progressListener);
			_urlLoader.addEventListener(Event.COMPLETE, completeListener);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, status);
			_urlLoader.load(request);			
		}

		public function get data():String
		{
			return _data;
		}
		
		public function get isExecuting():Boolean
		{
			return _isExecuting;
		}
		
		public function close():void
		{
			_urlLoader.close();
			_isExecuting = false;
		}
		
		private function progressListener(e:ProgressEvent):void {
			dispatchEvent(e);
		}

		private function status(e:HTTPStatusEvent):void {
			Logger.instance().info("HTTP status : ", e);
		}
		
		private function completeListener(e:Event):void
		{
			_isExecuting = false;
			_data = e.target.data;
			_urlLoader = e.currentTarget as URLLoader;
			_urlLoader.removeEventListener(Event.COMPLETE, completeListener);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, status);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function ioErrorListener(e:IOErrorEvent):void
		{
			_isExecuting = false;
			_urlLoader = e.currentTarget as URLLoader;
			_urlLoader.removeEventListener(Event.COMPLETE, completeListener);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, status);
			dispatchEvent(e);
		}

	}
}
