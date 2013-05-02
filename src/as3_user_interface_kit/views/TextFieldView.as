package as3_user_interface_kit.views
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class TextFieldView extends AbstractTextFieldView
	{
		private var _filters:Array;
		
		public function TextFieldView(filters:Array = null)
		{
			super();
			_textField = new TextField();
			_textField.tabEnabled = false;
			_textField.wordWrap = true;
			_textField.multiline = true;
			addChild(_textField);
			_filters = filters || new Array();
			
			_textField.addEventListener(Event.CHANGE, textWasChanged, false, 0, true);
		}
		
		private function textWasChanged(e:Event):void
		{
			_textField.defaultTextFormat = format;
			_textField.text = _textField.text;
			var numFilters:int = _filters.length;
			//var ts:Timestamp = new Timestamp();
			for (var i:int = 0; i < numFilters; i++)
			{
				_filters[i].filter(this);
			}
			//trace(ts);
		}
		
		override public function get text():String
		{
			return _textField.text;
		}
		
		override public function set text(char:String):void
		{
			_textField.defaultTextFormat = format;
			_textField.text = char;
			var numFilters:int = _filters.length;
			for (var i:int = 0; i < numFilters; i++)
			{
				_filters[i].filter(this);
			}
		}
		
		override public function set color(color:uint):void
		{
			super.color = color;
			_format.color = color;
			_textField.defaultTextFormat = _format;
			_textField.text = _textField.text;
		}
		
		override public function set size(size:int):void
		{
			super.size = size;
			_format.size = size;
			_textField.defaultTextFormat = format;
			_textField.text = _textField.text;
		}
		
	}
}