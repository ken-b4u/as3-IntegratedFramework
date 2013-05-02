package as3_foundation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import as3_foundation.log.Logger;

	[Event(name="complete", type="flash.events.Event")]
	public class Operation extends EventDispatcher
	{
		private var _isReady:Boolean = false;
		private var _isExecuting:Boolean = false;
		private var _wasFinish:Boolean = false;
		private var _wasCanceled:Boolean = false;

		private var _queue:OperationQueue;

		public function Operation()
		{
		}

		public function get queue():OperationQueue
		{
			return _queue;
		}

		public function set queue(q:OperationQueue):void
		{
			_queue = q;
		}

		public function get isReady():Boolean
		{
			return _isReady;
		}

		public function get isExecuting():Boolean
		{
			return _isExecuting;
		}

		public function get wasFinish():Boolean
		{
			return _wasFinish;
		}

		public function get wasCanceled():Boolean
		{
			return _wasCanceled;
		}

		protected function imReady():void
		{
			_isReady = true;
		}

		protected function imFinished():void
		{
			if (_queue) _queue.dvbinternal::operationWasFinish(this);
			_wasFinish = true;
			_isExecuting = false;
			dispatchEvent(new Event(Event.COMPLETE));
			//Logger.instance().info("Operation finished : " + this);
		}
		
		private var _progress:Number = 0;
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void {
			_progress = value;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, value, 1));
		}

		public function start():void
		{
			_isExecuting = true;
			main();
		}

		public function cancel():void
		{
			_wasCanceled = true;
			_isExecuting = false;
			if (_queue) _queue.dvbinternal::operationWasCanceled(this);
			Logger.instance().info("Operation canceled : " + this);
		}

		protected function main():void
		{

		}

		public function get status():String
		{
			var str:String = "isReady     : " + _isReady;
			str += "\nisFinished  : " + _wasFinish;
			str += "\nisExecuting : " + _isExecuting;
			str += "\nisCanceled  : " + _wasCanceled;
			return str;
		}
	}
}
