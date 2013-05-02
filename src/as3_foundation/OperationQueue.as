package as3_foundation
{
	import as3_foundation.evnets.OperationEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	[Event(name="operationComplete", type="foundation.evnets.OperationEvent")]
	
	public class OperationQueue extends EventDispatcher
	{
		private var _operations:Array;
		private var _currentOperation:Operation;
		private var _numProcessedOperation:int;
		
		private var _totalOperations:int = 0;
		
		public function OperationQueue()
		{
			_operations = new Array();
			_numProcessedOperation = 0;
		}
		
		public function addOperation(operation:Operation):void
		{
			operation.queue = this;
			
			if (_operations.length == 0)
			{
				DisplayLink.instance.addEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
			}
			_operations.push(operation);
			_totalOperations++;
		}
		
		public function addOperations(... operations):void
		{
			var numOperations:int = operations.length;
			for (var i:int = 0; i < numOperations; i++)
			{
				var operation:Operation = operations[i] as Operation;
				addOperation(operation);
			}
		}
		
		public function get operations():Array
		{
			return _operations;
		}
		
		public function get currentOperation():Operation
		{
			return _currentOperation;
		}
		
		public function get progress():Number {
			var p:Number = (_numProcessedOperation / _totalOperations);
			if (isNaN(p)) p = 0;
			if (_currentOperation) {
				if (p < 1) {
					p += _currentOperation.progress / _totalOperations;
				}
			}
			return p;
		}
		
		dvbinternal function operationWasFinish(o:Operation):void
		{
			_numProcessedOperation++;
			dispatchEvent(new OperationEvent(OperationEvent.OPERATION_COMPLETE, o));
			//Logger.instance().info("Complete a operation : " + o);
			
			if (_operations.length)
			{
				DisplayLink.instance.addEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
			}
			else
			{
				DisplayLink.instance.removeEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
			}
		}
		
		dvbinternal function operationWasCanceled(o:Operation):void
		{
			if (_operations.length)
			{
				DisplayLink.instance.addEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
			}
			else
			{
				DisplayLink.instance.removeEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
			}
		}
		
		private function checkState(e:Event):void
		{
			if (_operations[0].isReady)
			{
				_currentOperation = _operations.shift();
				DisplayLink.instance.removeEventListener(DisplayLinkEvent.DISPLAY_UPDATE, checkState);
				if (!_currentOperation.wasFinish && !_currentOperation.isExecuting) {
					_currentOperation.addEventListener(ProgressEvent.PROGRESS, _progress);
					_currentOperation.start();
				}
				else this.dvbinternal::operationWasFinish(_currentOperation);
			}
		}
		
		private function _progress(e:ProgressEvent):void {
			var r:Number = e.bytesLoaded / e.bytesTotal;
			if (r == 1) e.currentTarget.removeEventListener(ProgressEvent.PROGRESS, _progress);
			var p:Number = (_numProcessedOperation / _totalOperations);
			if (isNaN(p)) p = 0;
			if (p < 1) {
				p += r / _totalOperations;
			}
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, p, 1));
		}
		
		public function get numProcessedOperation():int
		{
			return _numProcessedOperation;
		}

		public function get totalOperations():int
		{
			return _totalOperations;
		}

		
	}
}