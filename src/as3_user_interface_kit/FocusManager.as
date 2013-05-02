package as3_user_interface_kit
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import as3_user_interface_kit.Application;
	
	/**
	 * FocusManager オブジェクトはコンテンツ内でのフォーカスをコントロールします。
	 */
	public class FocusManager implements IFocusable
	{
		private var _targets:Array;
		private var _currentIndex:int = -1;
		private var _currentTarget:IFocusable;
		
		
		/**
		 * コンストラクタ.
		 */
		public function FocusManager(targets:Array)
		{
			addTarget(targets);
		}
		
		
		/**
		 */
		private function addTarget(args:Array, c:Array = null):void
		{
			// この c には、常に親子関係の最上位の _targets が入る.
			var isRoot:Boolean = false;
			if (c == null)
			{
				// 無駄のないようにここで最上位の配列のみ生成 & リスナ登録
				_targets = new Array();
				c = _targets;
				Application.getDocumentClass().stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
				isRoot = true;
			}
			for (var i:int = 0; i < args.length; i++)
			{
				var t:IFocusable = args[i];
				// FocusManager がネストされていたら、階層下にある IFocusable 実装したインスタンスを、最上位の targets にセットする.
				if (t is FocusManager)
				{
					var a:Array = new Array();
					// ここで最上位の targets を引数に渡す.
					addTarget(FocusManager(t)._targets, c);
				}
				else
				{
					c.push(t);
				}
			}
			
			// 最上位のFocusManagerだったら、マウスイベントを監視.
			if (isRoot)
			{
				var numTargets:int = _targets.length;
				for (var j:int = 0; j < numTargets; j++)
				{
					var dsp:Sprite = IFocusable(_targets[j]).focusTarget;
					dsp.addEventListener(MouseEvent.CLICK, click, false, 0, true);
				}
			}
		}
		
		private function click(e:MouseEvent):void
		{
			var numTargets:int = _targets.length;
			for (var i:int = 0; i < numTargets; i++)
			{
				var f:IFocusable = _targets[i];
				if (IFocusable(_targets[i]).focusTarget == e.currentTarget)
				{
					if (_currentTarget && _currentTarget != f)
						_currentTarget.focusOut();
					_currentIndex = i;
					_currentTarget = f;
					break;
				}
			}
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (_targets.length == 0)
				return;
			
			if (e.keyCode == Keyboard.TAB)
			{
				if (!e.shiftKey)
				{
					next();
				}
				else
				{
					prev();
				}
			}
		}
		
		public function next():void
		{
			if (_currentIndex >= 0)
			{
				var old:IFocusable = _targets[_currentIndex];
				old.focusOut();
			}
			var _new:IFocusable;
			
			if (_currentIndex >= _targets.length - 1)
				_currentIndex = -1;
			_new = _targets[++_currentIndex];
			_new.focusIn();
			_currentTarget = _new;
		}
		
		public function prev():void
		{
			if (_currentIndex >= 0)
			{
				var old:IFocusable = _targets[_currentIndex];
				old.focusOut();
			}
			var _new:IFocusable;
			
			if (_currentIndex <= 0)
				_currentIndex = _targets.length;
			_new = _targets[--_currentIndex];
			_new.focusIn();
			_currentTarget = _new;
		}
		
		/**
		 * @private
		 */
		public function focusIn():void
		{
			// なにもしない
		}
		
		/**
		 * @private
		 */
		public function focusOut():void
		{
			// なにもしない
		}
		
		public function get focusTarget():Sprite
		{
			return null;
		}
		
	}
}