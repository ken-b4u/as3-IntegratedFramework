package as3_user_interface_kit.events
{
	import flash.events.Event;

	/**
	 * <code>ScrollEvent</code>クラスは、表示領域のスクロールに関連するイベントを定義します。次のようなイベントがあります。
	 * <ul>
	 * <li><code>SCROLL_UPDATE</code>:表示領域がスクロールされた時に送出されます。</li>
	 * </ul>
	 * @author tkn
	 *
	 */
	public class ScrollEvent extends Event
	{
		static public const SCROLL_UPDATE:String = "scrollUpdate";

		public function ScrollEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}