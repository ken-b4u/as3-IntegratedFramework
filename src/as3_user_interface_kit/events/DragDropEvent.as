package as3_user_interface_kit.events
{
	import flash.events.Event;
	
	import as3_user_interface_kit.controllers.IDraggableViewController;

	/**
	 * <code>DragDropEvent</code>クラスは、表示オブジェクトのDrag&amp;Dropに関連するイベントを定義します。次のようなイベントがあります。
	 * <ul>
	 * <li><code>CHANGE_RECEPTION</code>:Drag可能オブジェクトの受け入れ先が変更された時に送出されます。</li>
	 * <li><code>START_DRAG</code>:オブジェクトがDrag開始された時に送出されます。</li>
	 * <li><code>STOP_DRAG</code>:オブジェクトのDragが終了した時に送出されます。</li>
	 * </ul>
	 * @see ui.controllers.IDraggableViewController
	 * @see ui.controllers.DragReceptionController
	 * @author tkn
	 *
	 */
	public class DragDropEvent extends Event
	{
		static public const CHANGE_RECEPTION:String = "changeReception";
		static public const START_DRAG:String = "startDrag";
		static public const STOP_DRAG:String = "stopDrag";

		public var dragging:IDraggableViewController;

		public function DragDropEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}