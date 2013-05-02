package as3_user_interface_kit.views
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class HTMLTextFieldView extends AbstractTextFieldView
	{
		private var _filters:Array;
		
		public function HTMLTextFieldView(filters:Array = null)
		{
			super();
			_textField = new TextField();
			_textField.tabEnabled = false;
			_textField.wordWrap = true;
			_textField.multiline = true;
			addChild(_textField);
			
			_filters = filters;
			
			_textField.addEventListener(Event.CHANGE, textChange, false, 0, true);
		}
		
		private function textChange(e:Event):void
		{
			var numFilters:int = _filters.length;
			for (var i:int = 0; i< numFilters; i++)
			{
				_filters[i].filter(this);
			}
			
		}
		
		override protected function draw():void
		{
			super.draw();
			_textField.width = frame.width;
			_textField.height = frame.height;
		}
		
		override public function get text():String
		{
			return _textField.htmlText;
		}
		
		override public function set text(char:String):void
		{
			_textField.htmlText = "<p><font color='#" + _color.toString(16) + "' size='" + _size + "' face='" + _font + "'>" + char + "</font></p>";
			
			if (_filters == null)
				return;
			var numFilters:int = _filters.length;
			
			for (var i:int = 0; i< numFilters; i++)
			{
				_filters[i].filter(this);
			}
		}
		
		override public function set size(size:int):void
		{
			super.size = size;
			text = text;
		}
		
		override public function set color(color:uint):void
		{
			super.color = color;
			//_textField.htmlText = _htmlText.reset(_textField.text).toString();
			text = text;
		}
	}
}