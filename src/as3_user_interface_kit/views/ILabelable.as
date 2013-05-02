package as3_user_interface_kit.views {
	public interface ILabelable {
		/**
		 * ラベルに表示される文字列です.
		 * @return
		 *
		 */
		function get text():String;

		function set text(title:String):void;

		/**
		 * テキストの色です.
		 * @return
		 *
		 */
		function get color():uint;

		function set color(value:uint):void;

		/**
		 * テキストのサイズです.
		 * @return
		 *
		 */
		function get fontSize():int;

		function set fontSize(value:int):void;

		/**
		 * 埋め込みフォントを使用するかどうかの真偽値です.
		 * @return
		 *
		 */
		function get useEmbedFont():Boolean;

		function set useEmbedFont(value:Boolean):void;

		/**
		 * ラベルのフォントタイプです.
		 * @return
		 *
		 */
		function get fontType():String;

		function set fontType(type:String):void;
	}
}