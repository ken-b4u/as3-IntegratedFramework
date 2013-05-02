package as3_user_interface_kit.filters
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3_user_interface_kit.views.AbstractTextFieldView;
	
	public class RangeColorFilter implements ITextFilter
	{
		private var _s:String;
		private var _e:String;
		private var _c:uint;
		
		public function RangeColorFilter(startTag:String, endTag:String, color:uint)
		{
			_s = startTag;
			_e = endTag;
			_c = color;
		}
		
		public function filter(source:AbstractTextFieldView):void
		{
			var tf:TextField = source.textField;	
			var str:String = tf.text;
			var find:int;
			var preCount:int = 0;
			var fmt:TextFormat = source.format.clone();

			fmt.color = _c;
			var startLen:int = _s.length;
			var endLen:int = _e.length;
			
			while ((find = str.indexOf(_s)) > -1)
			{
				var start:int = find + preCount;
				var findStartLen:int = find + startLen;
				str = str.substring(findStartLen, str.length);
				
				var end:int = str.indexOf(_e);
				preCount += findStartLen;
				
				if (end >= 0)
				{
					var endEndLen:int = end + endLen;
					tf.setTextFormat(fmt, start, start + endEndLen + startLen);
					str = str.substring(endEndLen, str.length);
					preCount += endEndLen;
				}
				else 
				{
					tf.setTextFormat(fmt, start, tf.text.length);
				}
				
				if (str == _e)
					return;
			}
		}
	}
}