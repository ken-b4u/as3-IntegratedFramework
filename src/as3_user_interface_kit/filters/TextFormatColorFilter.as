package as3_user_interface_kit.filters
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3_user_interface_kit.views.AbstractTextFieldView;
	
	public class TextFormatColorFilter implements ITextFilter
	{
		private var _char:String;
		private var _color:uint;
		private var _reg:RegExp;
		//private var _current:String = "";
		
		public function TextFormatColorFilter(char:String, color:uint)
		{
			_char = char;
			_color = color;
			_reg = new RegExp(char, "g");
		}
		
		public function filter(source:AbstractTextFieldView):void
		{
			var str:String = source.text;
			var charLen:int = _char.length;
			var fmt:TextFormat = source.format.clone();
			fmt.color = _color;
			var tf:TextField = source.textField;
			var index:int = 0;
			var preCount:int = 0;
			while ((index = str.search(_reg)) > -1)
			{	
				var start:int = index + preCount;
				var incharlen:int = index + charLen;
				tf.setTextFormat(fmt, start, start + charLen);
				str = str.substring(incharlen, str.length);
				preCount += incharlen;
			}
			/*var str:String = source.text;
			var charLen:int = _char.length;
			var fmt:TextFormat = source.format.clone();
			fmt.color = _color;
			var tf:TextField = source.textField;
			var res:Object = _reg.exec(str);
			while (res)
			{
				var start:int = res.index;
				tf.setTextFormat(fmt, start, start + charLen);
				res = _reg.exec(str);
			}*/
		}
	}
}