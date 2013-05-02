package as3_user_interface_kit.views
{
	import as3_foundation.utils.TextFormatUtil;
	
	import as3_user_interface_kit.models.FLUITextFormat;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class ExTextField extends View
	{
		private var _viewTextField:TextField;
		private var _sourceTextField:TextField;
		private var _selectedFormat:TextFormat;
		private var _lines:Array = new Array();
		private var _overlay:Sprite;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;

		private var _selectedBgColor:uint = 0xff0000;
		private var _selectedColor:uint = 0xffffff;

		public function ExTextField()
		{
			super();
			/*var bg:DrawableView = new DrawableView(0, 0xffffff)
			backgroundImage = bg;*/

			width = 200;
			height = 200;

			_viewTextField = new TextField();
			_sourceTextField = new TextField();
			_viewTextField.wordWrap = _sourceTextField.wordWrap = true;
			_viewTextField.defaultTextFormat = _sourceTextField.defaultTextFormat = FLUITextFormat.instance().getInputTextFormat();
			_selectedFormat = FLUITextFormat.instance().getInputTextFormat();
			_viewTextField.type = _sourceTextField.type = TextFieldType.INPUT;
			_viewTextField.multiline = _sourceTextField.multiline = true;

			addChild(_viewTextField);

			_overlay = new Sprite();
			_overlay.mouseEnabled = false;

			_bitmapData = new BitmapData(10, 10, true, 0);
			_bitmap = new Bitmap(_bitmapData, "auto", true);
			_bitmap.visible = false;

			addChild(_overlay);
			addChild(_bitmap);

			addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		public function get defaultTextFormat():TextFormat
		{
			return _viewTextField.defaultTextFormat;
		}
		
		public function set defaultTextFormat(fmt:TextFormat):void
		{
			_viewTextField.defaultTextFormat = fmt;
			_selectedFormat = TextFormatUtil.clone(fmt);
			_sourceTextField.defaultTextFormat = _selectedFormat;
		}


		public function get textFieldSubstance():TextField
		{
			return _viewTextField;
		}

		public function get text():String
		{
			return _viewTextField.text;
		}

		public function set text(str:String):void
		{
			_viewTextField.text = str;
		}

		public function get selectedBackgroundColor():uint
		{
			return _selectedBgColor;
		}

		public function set selectedBackgroundColor(col:uint):void
		{
			_selectedBgColor = col;
		}

		public function get selectedColor():uint
		{
			return _selectedColor;
		}

		public function set selectedColor(col:uint):void
		{
			_selectedColor = col;
		}

		private function enterframe(evt:Event):void
		{
			_viewTextField.width = _sourceTextField.width = frame.width;
			_viewTextField.height = _sourceTextField.height = frame.height;
			_sourceTextField.scrollV = _viewTextField.scrollV;
			
			_overlay.graphics.clear();
			_overlay.graphics.beginFill(_selectedBgColor);
			var numLines:int = _viewTextField.numLines;
			var selB:int = _viewTextField.selectionBeginIndex;
			var selE:int = _viewTextField.selectionEndIndex;

			_sourceTextField.defaultTextFormat = _viewTextField.defaultTextFormat;
			if (selB != selE)
			{
				_sourceTextField.text = _viewTextField.text;
				_selectedFormat.color = _selectedColor;
				_sourceTextField.setTextFormat(_selectedFormat, selB, selE);
				_bitmap.bitmapData = new BitmapData(frame.width, frame.height, true, 0);
				_bitmap.bitmapData.draw(_sourceTextField);

				_viewTextField.alpha = 0;
				_bitmap.visible = true;
			}
			else
			{

				_viewTextField.alpha = 1;
				_bitmap.visible = false;
			}
			for (var i:int = 0; i < numLines; i++)
			{

				var p:Point = getBtoE(i);
				if (p == null)
					continue;
				if (p.x > selE)
					continue;

				if (p.x <= selB)
					p.x = selB;

				if (p.y > selE)
					p.y = selE;
				if (p.x > p.y)
					continue;

				var begin:Rectangle = _viewTextField.getCharBoundaries(p.x);
				if (p.y == _viewTextField.length)
					p.y--;
				var end:Rectangle = _viewTextField.getCharBoundaries(p.y);

				if (begin && end)
				{
					var w:int = -begin.x + end.x;
					var posY:int = begin.y - (_viewTextField.scrollV - 1) * begin.height;
					if (selE > p.y || selE == _viewTextField.length)
						w += end.width;

					if (posY + end.height >= frame.height)
						continue;
					_overlay.graphics.drawRect(begin.x, posY, w, end.height);
				}
			}

			_overlay.graphics.endFill();
		}


		private function getBtoE(line:int):Point
		{
			if (line >= _viewTextField.numLines)
				return null;

			var b:int = _viewTextField.getLineOffset(line);
			var e:int = b + _viewTextField.getLineLength(line);
			if (line + 1 < _viewTextField.numLines)
				e--;
			if (_viewTextField.text.charAt(e) != "")
			{
				var char:String = _viewTextField.text.charAt(e)
				if (char == "\r" || char == "\n")
					e--;
					//trace(char == "\r" || char == "\n",_tf.text)
			}
			return new Point(b, e);
		}

	}
}