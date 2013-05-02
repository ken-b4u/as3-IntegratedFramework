package as3_user_interface_kit.views {
	/**
	 * IDrawableComponent インターフェースは、線、塗の描画のためのAPIを提供します.
	 * @author takanosatoshi
	 *
	 */
	public interface IDrawable {
		/**
		 * 線の色です.
		 * @return
		 *
		 */
		function get borderColor():uint;

		function set borderColor(value:uint):void;

		/**
		 * 線が有るか無いかの真偽値です.
		 * @return
		 *
		 */
		function get useBorder():Boolean;

		function set useBorder(value:Boolean):void;

		/**
		 * 線幅です.
		 * @return
		 *
		 */
		function get borderWidth():Number;

		function set borderWidth(value:Number):void;

		/**
		 * 塗りの色です.
		 * @return
		 *
		 */
		function get backgroundColor():uint;

		function set backgroundColor(value:uint):void;

		/**
		 * 線と塗りの色を設定します.
		 * @param fillColor
		 * @param borderColor
		 *
		 */
		function changeColor(lineColor:uint, fillColor:uint):void;

		/**
		 * 描画を停止します。
		 *
		 */
		function lock():void;

		/**
		 * 描画を再開します。
		 *
		 */
		function unlock():void;
	}
}