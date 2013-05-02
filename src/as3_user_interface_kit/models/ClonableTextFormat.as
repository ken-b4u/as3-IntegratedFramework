package as3_user_interface_kit.models
{
	import flash.text.TextFormat;
	
	public class ClonableTextFormat extends TextFormat
	{
		public function ClonableTextFormat(font:String=null, size:Object=null, color:Object=null, bold:Object=null, italic:Object=null, underline:Object=null, url:String=null, target:String=null, align:String=null, leftMargin:Object=null, rightMargin:Object=null, indent:Object=null, leading:Object=null)
		{
			super(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		}
		
		public function clone():ClonableTextFormat
		{
			return new ClonableTextFormat(this.font, this.size, this.color, this.bold, this.italic, this.underline, this.url, this.target, this.align, this.leftMargin, this.rightMargin, this.indent, this.leading);
		}
	}
}