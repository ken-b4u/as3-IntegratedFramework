package as3_foundation.utils
{
	import flash.text.TextFormat;
	
	public class TextFormatUtil
	{
		public function TextFormatUtil()
		{
			throw new Error("インスタンスを作成できません");
		}
		
		public static function clone(fmt:TextFormat):TextFormat
		{
			return new TextFormat(fmt.font, fmt.size, fmt.color, fmt.bold, fmt.italic, fmt.underline, fmt.url, fmt.target, fmt.align, fmt.leftMargin, fmt.rightMargin, fmt.indent, fmt.leading);
		}
	}
}