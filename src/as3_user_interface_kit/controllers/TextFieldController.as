package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Application;
	import as3_user_interface_kit.Frame;
	import as3_foundation.dvbinternal;
	
	import as3_user_interface_kit.IFocusable;
	import as3_user_interface_kit.appearances.ITextFieldSkin;
	import as3_user_interface_kit.events.ScrollEvent;
	import as3_user_interface_kit.views.AbstractTextFieldView;
	import as3_user_interface_kit.views.ILabelable;
	import as3_user_interface_kit.views.View;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	/**
	 * テキストフィールドのコントローラです.
	 * <p>オリジナルのスキン, スクロールバーの自動表示/非表示, プレースホルダー, アラート表示, フォーカスイン/フォーカスアウト時の挙動など、
	 * テキストフィールドのユーザビリティを高めるための機能を実装しています。</p>
	 * <p>通常、ユーザーはアプリケーションに固有のスキンを定義するだけです。</p>
	 * @author takanosatoshi
	 *
	 */
	public class TextFieldController extends ViewController implements IFocusable, ILabelable
	{
		public var tabSize:int = 4;
		private var _alert:Boolean = false;
		private var _viewTextField:AbstractTextFieldView;
		private var _scrollBar:ScrollBarController;
		private var _strMem:String;
		private var _scrollbarIsBeingDragged:Boolean = false;
		private var _backgroundImageWhenAlert:View;
		private var _placeholder:String = "";
		
		private var _defaultColor:uint;
		private var _placeholderColor:uint;
		
		/**
		 * コンストラクタ.
		 * @see as3_user_interface_kit.configurations.ITextFieldConfig
		 */
		public function TextFieldController(config:ITextFieldSkin, textView:AbstractTextFieldView)
		{
			_viewTextField = textView;
			_defaultColor = _viewTextField.color;
			_placeholderColor = 0x666666;
			_viewTextField.type = TextFieldType.INPUT;
			view.addChild(_viewTextField);
			
			_scrollBar = config.getScrollBar();
			_scrollBar.scrollBarView.transitionSteps = 1;
			view.addChild(_scrollBar.view);
			
			view.backgroundImage = config.getBackgroundImage();
			_backgroundImageWhenAlert = config.getAlertBackgroundImage();
			
			_strMem = '';
			
			this.multiline = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			_scrollBar.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
			var tf:TextField = _viewTextField.textField;
			tf.addEventListener(Event.SCROLL, onTextScrollHandler);
			tf.addEventListener(Event.CHANGE, onTextChangeHandler);
			_viewTextField.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownOnTextField);
			tf.addEventListener(FocusEvent.FOCUS_OUT, textFieldFocusOut);
			//tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Application.getDocumentClass().stage.addEventListener(MouseEvent.CLICK, stageClickListener);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			_scrollBar.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
			var tf:TextField = _viewTextField.textField;
			tf.removeEventListener(Event.SCROLL, onTextScrollHandler);
			tf.removeEventListener(Event.CHANGE, onTextChangeHandler);
			tf.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownOnTextField);
			tf.removeEventListener(FocusEvent.FOCUS_OUT, textFieldFocusOut);
			//tf.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.CLICK, stageClickListener);
		}
		
		private function stageClickListener(e:MouseEvent):void
		{
			if (e.target != _viewTextField.textField)
				focusOut();
		}
		
		/**
		 * @inheritDoc
		 * @param w
		 * @param h
		 *
		 */
		override public function viewWillDraw():void
		{
			var w:Number = view.frame.width;
			var h:Number = view.frame.height;
			
			if (_scrollBar.needVisibility)
			{
				_scrollBar.view.frame.x = w - _scrollBar.view.frame.width;
				_scrollBar.view.frame.height = h;
				_scrollBar.view.setNeedDisplay();
			}
			
			
			var margin:int = 5;/*Math.min((view.frame.height - _viewTextField.textHeight) / 2, 5);
			if (margin <= 0)
				margin = 5;*/
			var frm:Frame = _viewTextField.frame;
			frm.width = w - margin * 2;
			frm.x = frm.y = margin;
			if (_scrollBar.needVisibility)
				frm.width -= _scrollBar.view.frame.width;
			frm.height = h;
			_viewTextField.setNeedDisplay();
			
			if (_alert)
			{
				_backgroundImageWhenAlert.frame.width = view.frame.width;
				_backgroundImageWhenAlert.frame.height = view.frame.height;
				_backgroundImageWhenAlert.setNeedDisplay();
			}
			
			onTextScrollHandler(null);
			check();
		}
		
		private function scrollUpdate(e:ScrollEvent):void
		{
			_scrollbarIsBeingDragged = true;
			_viewTextField.scrollV = Math.ceil(_viewTextField.maxScrollV * _scrollBar.scrollRatio);
			_scrollbarIsBeingDragged = false;
		}
		
		
		/**
		 * フィールドが複数行テキストフィールドであるかどうかを示します.
		 * @param value
		 *
		 */
		public function get multiline():Boolean
		{
			return _viewTextField.multiline;
		}
		
		public function set multiline(value:Boolean):void
		{
			_viewTextField.wordWrap = value;
			_viewTextField.multiline = value;
		}
		
		/**
		 * アラートメッセージを表示します.
		 * @param message 表示するメッセージ
		 * @param textColor メッセージの色
		 *
		 */
		public function alert(message:String, textColor:uint = 0xffffff):void
		{
			if (_alert)
				return;
			_alert = true;
			_viewTextField.displayAsPassword = false;
			_viewTextField.text = message;
			_viewTextField.color = textColor;
			
			_backgroundImageWhenAlert.frame.width = view.frame.width;
			_backgroundImageWhenAlert.frame.height = view.frame.height;
			_backgroundImageWhenAlert.setNeedDisplay();
			view.addChildAt(_backgroundImageWhenAlert, 0);
			view.backgroundImage.visible = false;
		}
		
		/**
		 * テキストフィールド内の現在のテキスト.
		 * @return
		 *
		 */
		public function get text():String
		{
			return _strMem;
		}
		
		public function set text(text:String):void
		{
			if (text == "" && _placeholder != null)
			{
				_viewTextField.color = _placeholderColor;
				_viewTextField.text = _placeholder;
			}
			else
			{
				_viewTextField.color = _defaultColor;
				_viewTextField.text = text;
			}
			_strMem = text;
			clearAlert();
			onTextChangeHandler()
		}
		
		/**
		 * 未入力の時に表示するプレースホルダー.
		 * @return
		 *
		 */
		public function get placeholder():String
		{
			return _placeholder;
		}
		
		public function set placeholder(str:String):void
		{
			_placeholder = str;
			if (_viewTextField.text == "")
			{
				_viewTextField.color = _placeholderColor;
				_viewTextField.text = _placeholder;
			}
		}
		
		/**
		 * 通常入力時のテキストの色.
		 * @return
		 *
		 */
		public function get color():uint
		{
			return _viewTextField.color;
		}
		
		public function set color(value:uint):void
		{
			_defaultColor = value;
			_viewTextField.color = value;
		}
		
		/**
		 * フォントサイズ.
		 * @return
		 *
		 */
		public function get fontSize():int
		{
			return _viewTextField.size;
		}
		
		public function set fontSize(value:int):void
		{
			_viewTextField.size = value;
		}
		
		/**
		 * 埋め込みフォントを使用するかどうかの真偽値.
		 * @return
		 *
		 */
		public function get useEmbedFont():Boolean
		{
			return _viewTextField.embedFonts;
		}
		
		public function set useEmbedFont(value:Boolean):void
		{
			_viewTextField.embedFonts = value;
		}
		
		/**
		 * フォントタイプ.
		 * @return
		 *
		 */
		public function get fontType():String
		{
			return _viewTextField.font;
		}
		
		public function set fontType(type:String):void
		{
			_viewTextField.font = type;
		}
		
		private function onTextScrollHandler(e:Event):void
		{
			// スクロールバーがドラッグされている時に_scrollBarのscrollRatioを操作すると、scrollUpdate
			// でMath.floorしている誤差が原因でバーがビクビクッってなる。
			// なので、キー操作でテキストフィールドがスクロールされた時のみ、スクロールの割合をバーにも反映させる。
			if (!_scrollbarIsBeingDragged)
			{
				var per:Number = (_viewTextField.scrollV - 1) / (_viewTextField.maxScrollV - 1);
				if (!isNaN(per))
				{
					_scrollBar.scrollBarView.dvbinternal::scrollRatio = per;
				}
			}
			check();
		}
		
		private function check():void
		{
			var visibleLine:int = _viewTextField.numLines - _viewTextField.maxScrollV + 1;
			if (_viewTextField.numLines > visibleLine)
				_scrollBar.isEnabled = true;
			else if (_scrollBar)
				_scrollBar.isEnabled = false;
		}
		
		private function onTextChangeHandler(e:Event = null):void
		{
			if (_alert)
			{
				if (_viewTextField.displayAsPassword)
					_viewTextField.displayAsPassword = true;
				_viewTextField.color = _defaultColor;
				_viewTextField.text = _strMem;
				clearAlert();
				
				_alert = false;
			}
			
			_strMem = _viewTextField.text;
			
			if (_scrollBar.contentSize != _viewTextField.textHeight || _scrollBar.view.frame.x != view.frame.width - _scrollBar.view.frame.width)
			{
				_scrollBar.contentSize = _viewTextField.textHeight;
				_scrollBar.view.setNeedDisplay();
				view.setNeedDisplay();
			}
			_scrollBar.scrollRatio = 1;
			
			if (e) dispatchEvent(e);
		}
		
		/**
		 * @inheritDoc
		 */
		public function focusIn():void
		{
			if (_alert)
			{
				if (_viewTextField.displayAsPassword)
					_viewTextField.displayAsPassword = true;
				clearAlert();
				_alert = false;
			}
			Application.getDocumentClass().stage.focus = _viewTextField.textField;
			
			if (_viewTextField.text != _strMem)
			{
				_viewTextField.color = _defaultColor;
				_viewTextField.text = _strMem;
				
			}
		}
		
		
		/**
		 * @inheritDoc
		 * */
		public function focusOut():void
		{
			var stage:Stage = Application.getDocumentClass().stage;
			if (stage.focus == _viewTextField)
				stage.focus = null;
		}
		
		private function textFieldFocusOut(e:FocusEvent = null):void
		{
			if (_viewTextField.text == "")
			{
				_viewTextField.color = _placeholderColor;
				_viewTextField.text = _placeholder;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get focusTarget():Sprite
		{
			return view;
		}
		
		private function onMouseDownOnTextField(e:MouseEvent):void
		{
			focusIn();
		}
		
		/**
		 * 内部の<code>TextField</code>への参照.
		 * @return
		 * @see flsah.text.TextField
		 */
		public function get textField():TextField
		{
			return _viewTextField.textField;
		}
		
		private function clearAlert():void
		{
			if (_alert && view.contains(_backgroundImageWhenAlert))
			{
				view.removeChild(_backgroundImageWhenAlert);
				view.backgroundImage.visible = true;
			}
		}
		
		/*private function keyDownListener(e:KeyboardEvent):void
		{
			var tf:TextField = textField;
			if(e.keyCode == Keyboard.TAB)
			{
				var str:String = tf.text.substr(0, tf.caretIndex);
				var tab:String = "";
				for (var i:int = 0; i < tabSize; i++)
				{
					tab += " ";
				}
				str += tab;
				var ind:int = str.length;
				str += tf.text.substring(tf.caretIndex, tf.text.length);
				text = str;
				tf.setSelection(ind, ind);
			}
		}*/
	}
}