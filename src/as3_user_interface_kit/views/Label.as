package as3_user_interface_kit.views
{
	import flash.display.Bitmap;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3_user_interface_kit.models.FLUITextFormat;


	public class Label extends AbstractLabel implements ILabelable
	{
		private var _textField:TextField;
		private var _text:String = "";
		private var _textFormat:TextFormat;
		private var _displayObject:Bitmap;

		public function Label()
		{
			_textField = new TextField();
			_textFormat = FLUITextFormat.instance().getLabelTextFormat();
			_textField.defaultTextFormat = _textFormat;
			_textField.selectable = false;
			_textField.mouseEnabled = false;

			addChild(_textField);
		}
		
		private var _numLines:int = 1;
		public function get numLines():int {
			return _numLines;
		}
		
		public function set numLines(line:int):void {
			_numLines = line;
		}
		
		public function get useDropShadow():Boolean
		{
			return filters[0].color == 0;
		}
		
		public function set useDropShadow(val:Boolean):void
		{
			if (val)
				filters = [new DropShadowFilter(1, 90, 0, 1, 1, 1, 3)];
			else 
				filters = [];
		}
		
		public function get useBevel():Boolean
		{
			return filters[0].color == 0xffffff;
		}
		
		public function set useBevel(val:Boolean):void
		{
			if (val)
				filters = [new DropShadowFilter(1, 90, 0xffffff, 1, 2, 2, 3)];
			else 
				filters = [];
		}
		
		public function get wordWrap():Boolean {
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
		}

		override public function sizeToFit():void
		{
			_textField.text = _text;
			frame.width = _textField.textWidth + 5;
			frame.height = _textField.textHeight + 5;
		}

		/**
		 * @inheritDoc
		 *
		 */
		override protected function draw():void
		{
			super.draw();
			if (frame.width == 0)
				return;

			_textField.text = _text;
			var w:Number = frame.width;
			var h:Number = frame.height;
			_textField.width = w;
			_textField.height = h;
			var cnt:int = 0;

			if (!this.wordWrap) {
				if (frame.width >= _textField.textWidth)
					return;
				
				// 整形
				var tw:Number = frame.width - _textField.textWidth / _textField.text.length * 2;
				if (tw < 0)
					return;
				
				while (_textField.textWidth >= tw) {
					cnt++;
					_textField.text = _textField.text.substr(0, _textField.text.length - 1);
				}
				if (cnt)
					_textField.appendText("...");
			} else {
				var cut:Boolean = false;
				while (_numLines < _textField.numLines) {
					_textField.text = _textField.text.substr(0, _textField.text.length - 1);
					cut = true;
				}
				if (cut) {
					_textField.text = _textField.text.substr(0, _textField.text.length - 3);
					_textField.appendText("...");
				}
			}
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get text():String
		{
			return _text;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function set text(title:String):void
		{
			if (title == null)
				return;
			_textField.text = title;
			_text = title;
			setNeedDisplay();
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get fontSize():int
		{
			return _textFormat.size as int;
		}

		override public function set fontSize(value:int):void
		{
			_textFormat.size = value;
			_textField.defaultTextFormat = _textFormat;
		}
		
		public function get bold():Boolean
		{
			return _textFormat.bold;
		}
		
		public function set bold(val:Boolean):void
		{
			_textFormat.bold = val;
			_textField.defaultTextFormat = _textFormat;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get color():uint
		{
			return _textFormat.color as uint;
		}

		override public function set color(value:uint):void
		{
			_textFormat.color = value;
			_textField.defaultTextFormat = _textFormat;
			_textField.text = _text;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get useEmbedFont():Boolean
		{
			return _textField.embedFonts;
		}

		override public function set useEmbedFont(value:Boolean):void
		{
			_textField.embedFonts = value;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get fontType():String
		{
			return _textFormat.font;
		}

		override public function set fontType(type:String):void
		{
			_textFormat.font = type;
			_textField.defaultTextFormat = _textFormat;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
			_textField.defaultTextFormat = _textFormat;
		}


	}
}