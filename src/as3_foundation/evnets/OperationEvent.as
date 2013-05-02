package as3_foundation.evnets
{
	import flash.events.Event;
	
	import as3_foundation.Operation;
	import as3_foundation.OperationQueue;
	
	public class OperationEvent extends Event
	{
		public static const OPERATION_COMPLETE:String = "operationComplete";
		
		private var _operation:Operation;
		
		public function OperationEvent(type:String, op:Operation, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_operation = op;
		}
		
		public function get operation():Operation
		{
			return _operation;
		}
		
		override public function clone():Event
		{
			return new OperationEvent(type, _operation, bubbles, cancelable);
		}
		
		public function get queue():OperationQueue
		{
			return this.currentTarget as OperationQueue;
		}
	}
}