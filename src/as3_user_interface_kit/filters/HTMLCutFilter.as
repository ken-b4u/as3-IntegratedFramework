package as3_user_interface_kit.filters
{
	import as3_user_interface_kit.views.AbstractTextFieldView;

	public class HTMLCutFilter implements ITextFilter
	{
		private var _char:String;
		private var _color:uint;
		
		private var _pattern:RegExp;
		private var _replace:String;
		
		public function HTMLCutFilter(char:String)
		{
			_char = char;
			
			_pattern = new RegExp(_char, "g");
			_replace = "";
		}
		
		public function filter(source:AbstractTextFieldView):void
		{
//			source = source.replace(_pattern, _replace);
//			return source;
			return;
		}
	}
}