package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.views.View;

	/**
	 * <code>ButtonController</code>クラスの設定用インターフェース.
	 * @see as3_user_interface_kit.controllers.ButtonController
	 */
	public interface IButtonSkin
	{
		/**
		 * 通常時のボタンスキンを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getNormalSkin():View;

		/**
		 * 押下時のボタンスキンを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getDownSkin():View;

		/**
		 * ロールオーバー時のボタンスキンを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getOverSkin():View;
	}
}