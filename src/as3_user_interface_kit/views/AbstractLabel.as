package as3_user_interface_kit.views
{

	public class AbstractLabel extends View implements ILabelable
	{
		public function AbstractLabel()
		{
			super();
		}

		public function get text():String
		{
			return null;
		}

		public function set text(title:String):void
		{
		}

		public function get color():uint
		{
			return 0;
		}

		public function set color(value:uint):void
		{
		}

		public function get fontSize():int
		{
			return 0;
		}

		public function set fontSize(value:int):void
		{
		}

		public function get useEmbedFont():Boolean
		{
			return false;
		}

		public function set useEmbedFont(value:Boolean):void
		{
		}

		public function get fontType():String
		{
			return null;
		}

		public function set fontType(type:String):void
		{
		}
	}
}