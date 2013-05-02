package as3_user_interface_kit.filters
{
	import as3_user_interface_kit.views.AbstractTextFieldView;

	public class HTMLColorFilter implements ITextFilter
	{
		private var _char:String;
		private var _color:uint;
		
		private var _pattern:RegExp;
		private var _replace:String;
		public function HTMLColorFilter(char:String, color:uint = 0x000000)
		{
			_char = char;
			_color = color;
			
			_pattern = new RegExp(_char, "g");
			_replace = "<font color='#" + _color.toString(16) + "'>" + _char + "</font>";
		}
		
		public function filter(source:AbstractTextFieldView):void
		{
			source.textField.htmlText = source.text.replace(_pattern, _replace);
		}
	}
}