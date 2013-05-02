package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.views.View;

	/**
	 * @author takanosatoshi
	 */
	public interface IDraggableViewController extends IViewController
	{

		/**
		 * ドラッグ開始時の挙動を実装します.
		 *
		 */
		function onDrag():void;

		/**
		 * ドロップ時の挙動を実装します.
		 *
		 */
		function onDrop():void;

		/**
		 * ドラッグキャンセル時の挙動を実装します.
		 *
		 */
		function onCancel():void;

		/**
		 * ドロップ可能状態を示す Bool 値です.
		 * @param can
		 *
		 */
		function get dropEnabled():Boolean;

		function set dropEnabled(can:Boolean):void;

		/**
		 * オブジェクトの受け入れ先オブジェクト.
		 * @param rec
		 * @see DragReception
		 */
		function get reception():DragReceptionController;

		function set reception(rec:DragReceptionController):void;

		/**
		 * ゴーストを返します.
		 */
		function get ghost():View;
	}
}
