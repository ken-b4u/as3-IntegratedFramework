package as3_foundation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SubdivideExecutor extends Operation
	{
		private var _numDivides:int;
		private var _index:int = 0;
		private var _timer:Timer;
		private var _timerInterval:Number;

		public function SubdivideExecutor(numDivides:int = 1, timerInterval:Number = 1/60)
		{
			super();

			_numDivides = numDivides;
			_timerInterval = timerInterval;
		}

		override public function start():void
		{
			super.start();
			if (_timer) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, update);
			}
			_timer = new Timer(_timerInterval);
			_timer.addEventListener(TimerEvent.TIMER, update);
			_timer.start();
		}
		
		public function pause():void {
			_timer.stop();
		}
		
		public function resume():void {
			_timer.start();
		}

		private function update(e:TimerEvent):void
		{
			execute(_index++);
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _index / _numDivides, 1));
			if (_index == _numDivides)
				imFinished();
		}
		
		override public function get progress():Number
		{
			return _index / _numDivides;
		}

		protected function execute(index:int):void
		{

		}

		override public function cancel():void
		{
			super.cancel();
			_timer.removeEventListener(TimerEvent.TIMER, update);
		}

		override protected function imFinished():void
		{
			super.imFinished();
			_timer.removeEventListener(TimerEvent.TIMER, update);
		}

		public function get numDivides():int
		{
			return _numDivides;
		}

		public function set numDivides(value:int):void
		{
			_numDivides = value;
		}

	}
}