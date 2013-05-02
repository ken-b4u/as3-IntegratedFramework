package as3_user_interface_kit
{
	
	import flash.display.DisplayObject;

	public class DisplayObjectUtil
	{

		public function DisplayObjectUtil()
		{
			throw new Error("インスタンスを作成できません");
		}

		public static function fitToFrame(target:DisplayObject, container:Frame):void
		{
			var ratio:Number;
			if (target.width > container.width || target.height > container.height)
			{
				var rw:Number = container.width / target.width;
				var rh:Number = container.height / target.height;
				ratio = Math.min(rw, rh);
				target.width *= ratio;
				target.height *= ratio;
			}
		}

		public static function centering(target:DisplayObject, container:Frame):void
		{
			target.x = (container.width - target.width) / 2;
			target.y = (container.height - target.height) / 2;
		}
	}
}