package as3_user_interface_kit.controllers
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	public class DeepLinkViewStackController extends ViewStackController
	{
		public function DeepLinkViewStackController(contents:Array)
		{
			super(contents);
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, swfAddressChangeListener);
		}

		private function swfAddressChangeListener(e:SWFAddressEvent):void
		{
			var path:String = SWFAddress.getPathNames()[0];
			if (path == null)
				return;

			var numStacks:int = super.numStacks;

			for (var i:int = 0; i < numStacks; i++)
			{
				var id:String = IDeepLinkableViewController(getStackAt(i)).sceneID;
				if (path.substr(0, id.length) == id)
				{
					super.changeViewStack(i);
				}
			}
		}

	}
}