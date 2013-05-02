package as3_foundation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 指定時間後に<code>Performer</code>インスタンスの<code>perform</code>メソッドを呼び出します。 
	 * @author tkn
	 * 
	 */	
	public class Wait
	{
		private var _timer:Timer;
		private var _callback:Performer;
		
		/**
		 * 
		 * @param delay 待機時間
		 * @param pfm <code>Performer</code>インスタンス
		 * 
		 */		
		public function Wait(delay:Number, pfm:Performer)
		{
			_timer = new Timer(delay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			_timer.start();
			_callback = pfm;
		}
		
		public function cancel():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			_timer.stop();
			_timer = null;
			_callback = null;
		}
		
		private function timerComplete(e:TimerEvent):void
		{
			_callback.perform();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
		}
	}
}