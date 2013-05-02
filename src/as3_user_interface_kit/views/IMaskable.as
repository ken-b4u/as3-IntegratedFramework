package as3_user_interface_kit.views {
	import flash.display.DisplayObject;
	
	import as3_user_interface_kit.Frame;

	/**
	 * マスク操作APIを提供するインターフェースです.
	 * @author takanosatoshi
	 *
	 */
	public interface IMaskable {
		/**
		 * マスク矩形の Frame オブジェクト.
		 */
		function get maskFrame():Frame;

		function set maskFrame(mask:Frame):void;

		/**
		 * マスキング対象オブジェクトを追加します.
		 * @param childs  追加する表示オブジェクト
		 *
		 */
		function addChildToMaskedPane(child:DisplayObject):void;

		/**
		 *　マスキング対象オブジェクトを削除します.
		 * @param childs  削除する表示オブジェクト
		 *
		 */
		function removeChildFromMaskingPane(child:DisplayObject):void;
	}
}