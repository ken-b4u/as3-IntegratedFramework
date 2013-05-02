package as3_user_interface_kit.events
{
	import flash.events.Event;

	/**
	 * @private
	 * <code>ViewControllerEvent</code>クラスは、<code>ViewController</code>に関連するイベントを定義します。次のようなイベントがあります。
	 * <ul>
	 * <li><code>ViewControllerEvent</code>:Viewが表示リストから削除可能になった時に送出されます。</li>
	 * </ul>
	 * @see ui.controllers.ViewController
	 * @author tkn
	 *
	 */
	public class ViewControllerEvent extends Event
	{
		public static const VIEW_CAN_REMOVE_FROM_DISPLAY:String = "viewCanRemoveFromDisplay";

		//public static const VIEW_CANT_REMOVE_FROM_DISPLAY:String = "viewCantRemoveFromDisplay";

		public function ViewControllerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}