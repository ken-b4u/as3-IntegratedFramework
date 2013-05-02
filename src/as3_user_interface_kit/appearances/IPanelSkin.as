package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.views.View;

	/**
	 * <code>PanelController</code>の設定クラス用のインターフェース.
	 * @see as3_user_interface_kit.controllers.PanelController
	 */
	public interface IPanelSkin
	{
		/**
		 * パネルの背景に使用するビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getBackgroundImage():View;

		/**
		 * パネルの閉じるボタンのビューを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ButtonController
		 */
		function getCloseButton():ButtonController;
	}
}