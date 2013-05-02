package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.views.View;

	/**
	 * <code>ToggleButtonController</code>の設定用インターフェース.
	 * @see as3_user_interface_kit.controllers.ToggleButtonController
	 */
	public interface IToggleButtonSkin extends IButtonSkin
	{
		/**
		 * ON 状態の時のビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getOnIcon():View;

		/**
		 * OFF 状態の時のビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getOffIcon():View;
	}
}