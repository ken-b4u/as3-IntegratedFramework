package as3_user_interface_kit.events
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	/**
	 *　<code>ExMouseEvent</code>クラスは、MouseEventに関連するイベントを定義します。次のようなイベントがあります。
	 * <ul>
	 * <li><code>MOUSE_DOWN_LONG_TIME</code>:表示オブジェクト上でMouseDownしたまま一定の時間が経過した後、連続的に送出されます。</li>
	 * </ul>
	 * @author takanosatoshi
	 *
	 */
	public class ExMouseEvent extends MouseEvent
	{
		static public const MOUSE_DOWN_LONG_TIME:String = "mouseDownLongTime";

		public function ExMouseEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = 0, localY:Number = 0, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
	}
}