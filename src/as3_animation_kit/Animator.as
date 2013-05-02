package as3_animation_kit
{
	import as3_animation_kit.events.AnimationEvent;
	
	import as3_user_interface_kit.Application;
	import as3_foundation.Performer;
	import as3_foundation.Wait;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * アニメーション終了時に送出されます.
	 * @eventType as3_animation_kit.events.AnimationEvent.COMPLETE
	 */
	[Event(name="complete", type="as3_animation_kit.events.AnimationEvent")]

	/**
	 * <code>Animator</code>クラスは<code>NumericalInterpolator</code>をTweenerライクに使用するためのラッパークラスです.
	 *
	 * <p>
	 * <code>NumericalInterpolator</code>を使用したほうが高速な動作が期待できますが、
	 * より手軽にアニメーションさせたい場合は Animator クラスを使用します。
	 * </p>
	 * 　
	 * @author tkn
	 *
	 */
	public class Animator extends EventDispatcher
	{
		private var _delay:Number = 0;
		private var _target:Object;
		private var _param:String;
		private var _interpolator:NumericalInterpolator;
		private var _to:Number = 0;
		private var _numFrames:int = 1;
		private var _easing:IEasing;
		
		private var _cnt:int = 0;
		private var _values:Array;
		
		private var _compPerformer:Performer;
		private var _updatePerformer:Performer;
		
		private var _next:Animator;
		
		private var _wait:Wait;

		/**
		 * ループモードの ON/OFF.
		 */
		public var loopMode:Boolean = false;
		private var _running:Boolean = false;
		
		public function Animator()
		{
		}

		public function get running():Boolean
		{
			return _running;
		}

		public function tween(target:Object, param:String, to:Number, numFrames:int, easing:IEasing, delay:Number = 0):Animator
		{
			_target = target;
			_param = param;
			_to = to;
			_numFrames = numFrames;
			_easing = easing;

			var totalDelay:Number = _delay + delay;
			if (totalDelay)
			{
				if (_wait) _wait.cancel();
				_wait = new Wait(totalDelay, new Performer(this, start));
			}
			else
				start();
			
			_next = new Animator();
			_next._delay = totalDelay + 1000/Application.frameRate*numFrames;
			_running = true;
			return this;
		}
		
		public function complete(performer:Performer):Animator
		{
			_compPerformer = performer;
			return this;
		}
		
		public function update(performer:Performer):Animator
		{
			_updatePerformer = performer;
			return this;
		}

		private function start():void
		{
			_values = new NumericalInterpolator(_to, _target[_param], _numFrames, _easing).getData();
			Application.getDocumentClass().addEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		public function cancel():void {
			_delay = 0;
			_target = null;
			_param = null;
			_interpolator = null;
			_values = null;
			
			if (_wait) {
				_wait.cancel();
				_wait = null;
			}
			Application.getDocumentClass().removeEventListener(Event.ENTER_FRAME, enterFrameListener);
			_running = false;
			_compPerformer = null;
			_updatePerformer = null;
		}
		
		private function enterFrameListener(e:Event):void
		{
			_target[_param] = _values[_cnt++];
			if (_updatePerformer)
				_updatePerformer.perform();
			if (_cnt >= _numFrames)
			{
				_cnt = 0;
				Application.getDocumentClass().removeEventListener(Event.ENTER_FRAME, enterFrameListener);
				dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE));
				_running = false;
				if (_compPerformer)
					_compPerformer.perform();
			}
		}
		
		public function get next():Animator {
			return _next;
		}
		
		public function get progress():Number {
			return _cnt / _numFrames;
		}
	}
}