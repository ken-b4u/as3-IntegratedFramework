package as3_user_interface_kit.models
{
	import as3_user_interface_kit.filters.HTMLColorFilter;
	import as3_user_interface_kit.filters.RangeColorFilter;
	import as3_user_interface_kit.filters.TextFormatColorFilter;

	public class AS3EditorSyntaxHightligtDefine
	{
		public static const HTML_FILTERS:Array = Array([
			new HTMLColorFilter("package", 0xb03cd7),
			new HTMLColorFilter("class", 0xb03cd7),
			
			new HTMLColorFilter("private", 0x0000ff),
			new HTMLColorFilter("public", 0x0000ff),
			new HTMLColorFilter("protected", 0x0000ff),
			new HTMLColorFilter("internal", 0x0000ff),
			
			new HTMLColorFilter("static", 0x0000ff),
			new HTMLColorFilter("const", 0x0000ff),
			new HTMLColorFilter("import", 0x0000ff),
			new HTMLColorFilter("new", 0x0000ff),
			new HTMLColorFilter("extends", 0x0000ff),
			new HTMLColorFilter("implements", 0x0000ff),
			new HTMLColorFilter("true", 0x0000ff),
			new HTMLColorFilter("false", 0x0000ff),
			new HTMLColorFilter("super", 0x0000ff),
			new HTMLColorFilter("override", 0x0000ff),
			new HTMLColorFilter("null", 0x0000ff),
			new HTMLColorFilter("return", 0x0000ff),
			new HTMLColorFilter("set", 0x0000ff),
			new HTMLColorFilter("get", 0x0000ff),
			new HTMLColorFilter("void", 0x0000ff),
			
			new HTMLColorFilter("var", 0x70a0d0),
			
			new HTMLColorFilter("function", 0x51a87c),
			
			//new RangeColorFilter("/*", "*/", 0x51a87c),
			//new RangeColorFilter('"', '"', 0xff0000)
		]);
		
		public static const TEXT_FORMAT_FILTERS:Array = Array([
			new TextFormatColorFilter("package", 0xb03cd7),
			new TextFormatColorFilter("class", 0xb03cd7),
			
			new TextFormatColorFilter("private", 0x0000ff),
			new TextFormatColorFilter("public", 0x0000ff),
			new TextFormatColorFilter("protected", 0x0000ff),
			new TextFormatColorFilter("internal", 0x0000ff),
			
			new TextFormatColorFilter("static", 0x0000ff),
			new TextFormatColorFilter("const", 0x0000ff),
			new TextFormatColorFilter("import", 0x0000ff),
			new TextFormatColorFilter("new", 0x0000ff),
			new TextFormatColorFilter("extends", 0x0000ff),
			new TextFormatColorFilter("implements", 0x0000ff),
			new TextFormatColorFilter("true", 0x0000ff),
			new TextFormatColorFilter("false", 0x0000ff),
			new TextFormatColorFilter("super", 0x0000ff),
			new TextFormatColorFilter("override", 0x0000ff),
			new TextFormatColorFilter("null", 0x0000ff),
			new TextFormatColorFilter("return", 0x0000ff),
			new TextFormatColorFilter("set", 0x0000ff),
			new TextFormatColorFilter("get", 0x0000ff),
			new TextFormatColorFilter("void", 0x0000ff),
			
			new TextFormatColorFilter("var", 0x70a0d0),
			
			new TextFormatColorFilter("function", 0x51a87c),
			
			new RangeColorFilter("/*", "*/", 0x51a87c),
			new RangeColorFilter('"', '"', 0xff0000)
		]);
		/*private static const F0xb03cd7:TextFormat = new TextFormat("_sans", 14, 0xb03cd7);
		private static const F0x0000ff:TextFormat = new TextFormat("_sans", 14, 0x0000ff);
		private static const F0x70a0d0:TextFormat = new TextFormat("_sans", 14, 0x70a0d0);
		private static const F0x51a87c:TextFormat = new TextFormat("_sans", 14, 0x51a87c);
		
		public static const TEXT_FORMAT_FILTERS:Array = Array([
			new TextFormatFilter("package", F0xb03cd7),
			new TextFormatFilter("class", F0xb03cd7),
			
			new TextFormatFilter("private", F0x0000ff),
			new TextFormatFilter("public", F0x0000ff),
			new TextFormatFilter("protected", F0x0000ff),
			new TextFormatFilter("internal", F0x0000ff),
			
			new TextFormatFilter("static", F0x0000ff),
			new TextFormatFilter("const", F0x0000ff),
			new TextFormatFilter("new", F0x0000ff),
			new TextFormatFilter("extends", F0x0000ff),
			
			new TextFormatFilter("var", F0x70a0d0),
			
			new TextFormatFilter("function", F0x51a87c),
			
		]);*/
		
		public function AS3EditorSyntaxHightligtDefine()
		{
		}
	}
}
