package as3_user_interface_kit.filters
{
	import as3_user_interface_kit.views.AbstractTextFieldView;
	
	import flash.text.TextFormat;
	
	public class TextFormatFilter implements ITextFilter
	{
		private var _char:String;
		private var _format:TextFormat;
		
		public function TextFormatFilter(char:String, fmt:TextFormat)
		{
			_char = char;
			_format = fmt;
		}
		
		public function filter(source:AbstractTextFieldView):void
		{
			var str:String = source.text;
			var find:int;
			var charLen:int = _char.length;
			var preCount:int = 0;
			
			while ((find = str.indexOf(_char)) > -1)
			{
				var start:int = find + preCount;
				source.textField.setTextFormat(_format, start, start + charLen);
				
				var old:int = find + charLen;
				str = str.substring(old, str.length);
				preCount += old;
			}
		}
		
	}
}