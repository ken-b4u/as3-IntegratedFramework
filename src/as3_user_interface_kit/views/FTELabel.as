package as3_user_interface_kit.views
{
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.BreakOpportunity;

	public class FTELabel extends AbstractLabel implements ILabelable
	{
		private var _format:ElementFormat;
		private var _element:TextElement;
		private var _textBlock:TextBlock;
		private var _wordwrap:Boolean = false;

		private var _textLines:Array;

		private var _realyText:String;

		public function FTELabel(fmt:ElementFormat)
		{
			super();
			//backgroundImage = new DrawableView(0xff0000)
			_format = fmt.clone();
			_format.breakOpportunity = BreakOpportunity.NONE;
			mouseEnabled = false;
			mouseChildren = false;

			_textLines = new Array();
			_element = new TextElement("", _format);
			_textBlock = new TextBlock(_element);
			_textBlock.baselineZero = TextBaseline.IDEOGRAPHIC_TOP;
			_textBlock.baselineFontSize = _format.fontSize;
			_textBlock.baselineFontDescription = _format.fontDescription;
		}


		public function get wordwrap():Boolean
		{
			return _wordwrap;
		}

		public function get elementFormat():ElementFormat
		{
			return _element.elementFormat;
		}

		public function set wordwrap(value:Boolean):void
		{
			_wordwrap = value;
		}

		override public function get text():String
		{
			return _realyText;
		}

		override public function set text(title:String):void
		{
			_element.text = title;
			_realyText = title;
			dispose();
			add();
		}

		override public function sizeToFit():void
		{
			_element.text = _realyText;
			var line:TextLine = _textBlock.createTextLine(null);
			if (line)
			{
				frame.width = line.width;
				frame.height = line.height;
			}
			text = _realyText;
		}

		override public function get color():uint
		{
			return _format.color;
		}

		override public function set color(value:uint):void
		{
			if (_format.locked)
				_format = _format.clone();
			_format.color = value;
			refresh();
		}

		override public function get fontSize():int
		{
			return _format.fontSize;
		}

		override public function set fontSize(value:int):void
		{
			if (_format.locked)
				_format = _format.clone();
			_format.fontSize = value;
			refresh();
		}

		override public function get useEmbedFont():Boolean
		{
			return false;
		}

		override public function set useEmbedFont(value:Boolean):void
		{

		}

		override public function get fontType():String
		{
			return _format.fontDescription.fontName;
		}

		override public function set fontType(type:String):void
		{
			var desc:FontDescription = _format.fontDescription.clone();
			if (_format.locked)
				_format = _format.clone();
			desc.fontName = type;
			_format.fontDescription = desc;
			refresh();
		}

		private function refresh():void
		{
			dispose();
			_element.elementFormat = _format;
			add();
		}

		private function add():void
		{
			var textLine:TextLine;
			if (_wordwrap)
			{

				textLine = _textBlock.createTextLine(null, width);
				while (textLine)
				{
					textLine.y = _textLines.length * textLine.height;
					_textLines.push(textLine);
					textLine = _textBlock.createTextLine(textLine, width);
				}
			}
			else
			{
				//textLine = _textBlock.createTextLine(null);
				textLine = _textBlock.createTextLine(null, width < 0 ? 0 : width);

				var str:String = _realyText;
				if (textLine && textLine.rawTextLength < str.length)
				{
					str = str.substr(0, textLine.rawTextLength - 4);
					str += "...";
					_element.text = str;
					textLine = _textBlock.createTextLine(null, width);
				}
				/*if (textLine && frame.width > 0)
				{
					while (textLine.width > frame.width)
					{
						str = str.substr(0, str.length - 4);
						str += "...";
						_element.text = str;
						if (str == "...")
							break;
						textLine = _textBlock.createTextLine(null);
					}
				}*/
				if (textLine)
					_textLines.push(textLine);
			}


			var numLines:int = _textLines.length;
			if (numLines)
				for (var i:int = 0; i < numLines; i++)
					addChild(_textLines[i]);
		}

		private function dispose():void
		{
			while (_textLines.length)
			{
				var line:TextLine = _textLines.pop();
				removeChild(line);
				line.flushAtomData();
			}
		}


	}
}