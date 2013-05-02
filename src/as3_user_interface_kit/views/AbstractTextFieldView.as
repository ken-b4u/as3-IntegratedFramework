package as3_user_interface_kit.views
{
	import flash.text.TextField;
	
	import as3_user_interface_kit.models.FLUITextFormat;
	import as3_user_interface_kit.models.ClonableTextFormat;

	public class AbstractTextFieldView extends View
	{
		protected var _textField:TextField;
		protected var _format:ClonableTextFormat;
		protected var _color:uint = 0x000000;
		protected var _font:String = "_sans";
		protected var _size:int = 12;
		public function AbstractTextFieldView()
		{
			super();
			_textField = new TextField();
			_format = FLUITextFormat.instance().getLabelTextFormat().clone();
		}
		
		public function get text():String
		{
			return null;
		}
		
		public function set text(str:String):void
		{
			
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get size():int{return _size;}
		public function set size(size:int):void{_size = size;}
		
		public function get color():uint{return _color;}
		public function set color(color:uint):void{_color = color}
		
		public function get font():String{return _font;}
		public function set font(font:String):void{_font = font};
		
		public function get format():ClonableTextFormat{
			return _format;
		}
		public function set format(fmt:ClonableTextFormat):void{
			_format = fmt;
			_textField.defaultTextFormat = _format;
		}
		
		override protected function draw():void
		{
			super.draw();
			_textField.width = width;
			_textField.height = height;
		}
		
		///////////////////////////////////////////////////////
		public function get alwaysShowSection():Boolean
		{
			return _textField.alwaysShowSelection;
		}
		
		public function set alwaysShowSection(v:Boolean):void
		{
			_textField.alwaysShowSelection = v;
		}
		
		public function get antiAliasType():String
		{
			return _textField.antiAliasType;
		}
		
		public function set antiAliasType(type:String):void
		{
			_textField.antiAliasType = type;
		}
		
		public function get bottomScrollV():int
		{
			return _textField.bottomScrollV;
		}
		
		public function get caretIndex():int
		{
			return _textField.caretIndex;
		}
		
		public function get condenseWhite():Boolean
		{
			return _textField.condenseWhite;
		}
		
		public function set condenseWhite(v:Boolean):void
		{
			_textField.condenseWhite = v;
		}
		
		public function get displayAsPassword():Boolean
		{
			return _textField.displayAsPassword;
		}
		
		public function set displayAsPassword(v:Boolean):void
		{
			_textField.displayAsPassword = v;
		}
		
		public function get embedFonts():Boolean
		{
			return _textField.embedFonts;
		}
		
		public function set embedFonts(v:Boolean):void
		{
			_textField.embedFonts = v;
		}
		
		public function get gridFitType():String
		{
			return _textField.gridFitType;
		}
		
		public function set gridFitType(type:String):void
		{
			_textField.gridFitType = type;
		}
		
		public function get length():int
		{
			return _textField.length;
		}
		
		public function get maxChars():int
		{
			return _textField.maxChars;
		}
		
		public function set maxChars(max:int):void
		{
			_textField.maxChars = max;
		}
		
		public function get maxScrollH():int
		{
			return _textField.maxScrollH;
		}
		
		public function get maxScrollV():int
		{
			return _textField.maxScrollV;
		}
		
		public function get multiline():Boolean
		{
			return _textField.multiline;
		}
		
		public function set multiline(val:Boolean):void
		{
			_textField.multiline = val;
		}
		
		public function get numLines():int
		{
			return _textField.numLines;
		}
		
		public function get restrict():String
		{
			return _textField.restrict;
		}
		
		public function set restrict(r:String):void
		{
			_textField.restrict = r;
		}
		
		public function get scrollH():int
		{
			return _textField.scrollH;
		}
		
		public function set scrollH(v:int):void
		{
			_textField.scrollH = v;
		}
		
		public function get scrollV():int
		{
			return _textField.scrollV;
		}
		
		public function set scrollV(v:int):void
		{
			_textField.scrollV = v;
		}
		
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}
		
		public function set selectable(v:Boolean):void
		{
			_textField.selectable = v;
		}
		
		public function get selectionBeginIndex():int
		{
			return _textField.selectionBeginIndex;
		}
		
		public function get selectionEndIndex():int
		{
			return _textField.selectionEndIndex;
		}
		
		public function get sharpness():Number
		{
			return _textField.sharpness;
		}
		
		public function set sharpness(v:Number):void
		{
			_textField.sharpness = v;
		}
		
		public function get textHeight():Number
		{
			return _textField.textHeight;
		}
		
		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
		
		public function get thickness():Number
		{
			return _textField.thickness;
		}
		
		public function set thickness(v:Number):void
		{
			_textField.thickness = v;
		}
		
		public function get type():String
		{
			return _textField.type;
		}
		
		public function set type(v:String):void
		{
			_textField.type = v;
		}
		
		public function get useRichTextClipboard():Boolean
		{
			return _textField.useRichTextClipboard;
		}
		
		public function set useRichTextClipboard(v:Boolean):void
		{
			_textField.useRichTextClipboard = v;
		}
		
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap(v:Boolean):void
		{
			_textField.wordWrap = v;
		}
		
	}
}