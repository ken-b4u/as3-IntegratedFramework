package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.views.View;

	/**
	 * <code>TextFieldController</code> クラスの設定用インターフェース.
	 * @see as3_user_interface_kit.controllers.TextFieldController
	 */
	public interface ITextFieldSkin extends IScrollViewSkin
	{
		/**
		 * テキストフィールドの背景に使用するビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getBackgroundImage():View;

		/**
		 * テキストフィールドの背景（アラート時)に使用するビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getAlertBackgroundImage():View;
	}
}