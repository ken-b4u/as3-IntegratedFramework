package as3_foundation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import as3_foundation.evnets.OperationEvent;

	public class OperationBatch extends EventDispatcher
	{
		private var _operations:Array;
		private var _numProcessedOperation:int;
		private var _totalOperations:int = 0;
		
		
		public function OperationBatch()
		{
			_operations = new Array();
			_numProcessedOperation = 0;
		}
		
		public function addOperation(operation:Operation):void
		{
			_operations.push(operation);
			operation.addEventListener(Event.COMPLETE, operationWasCompleted);
			operation.start();
			_totalOperations++;
		}
		
		public function addOperations(... operations):void
		{
			var numOperations:int = operations.length;
			for (var i:int = 0; i < numOperations; i++)
			{
				var operation:Operation = operations[i] as Operation;
				operation.addEventListener(Event.COMPLETE, operationWasCompleted);
				addOperation(operation);
				operation.start();
				_totalOperations++;
			}
		}
		
		private function operationWasCompleted(e:Event):void
		{
			var op:Operation = e.currentTarget as Operation;
			op.removeEventListener(Event.COMPLETE, operationWasCompleted);
			_numProcessedOperation++;
			dispatchEvent(new OperationEvent(OperationEvent.OPERATION_COMPLETE, op));
		}
		
	}
}