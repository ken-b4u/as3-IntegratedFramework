package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.views.View;

	/**
	 * <code>HorizontalScrollBarView</code>,<code>VerticalScrollBarView</code>クラスの設定用インターフェース.
	 * @see as3_user_interface_kit.views.HorizontalScrollBarView
	 * @see as3_user_interface_kit.views.VerticalScrollBarView
	 */
	public interface IScrollBarViewSkin
	{
		/**
		 * スクロールバーのハンドルビューを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ButtonController
		 */
		function getHandle():View;

		/**
		 * スクロール比を最小値に近づけるボタンビューを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ButtonController
		 */
		function getUpButton():ButtonController;

		/**
		 * スクロール比を最大値に近づけるボタンビューを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ButtonController
		 */
		function getDownButton():ButtonController;

		/**
		 * スクロールバーのレールビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getRail():View;
	}
}