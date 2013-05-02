package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.controllers.ToggleButtonController;
	import as3_user_interface_kit.views.AbstractLabel;
	import as3_user_interface_kit.views.VerticalScrollBarView;
	import as3_user_interface_kit.views.View;

	/**
	 * <code>DropdownListController</code> クラスの設定用インターフェース.
	 * @see as3_user_interface_kit.controllers.DropdownListController
	 */
	public interface IDropdownListSkin
	{
		/**
		 * <code>VerticalScrollBarView</code>を返します.
		 * @return
		 * @see as3_user_interface_kit.views.VerticalScrollBarView
		 */
		function getScrollBarView():VerticalScrollBarView;

		/**
		 * 最上位の行ビューを返します.
		 * @return
		 * @see as3_user_interface_kit.views.View
		 */
		function getRootRow():View;

		function getPlaceholder():AbstractLabel;

		/**
		 * 開閉操作用のトグルボタンを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ToggleButtonController
		 */
		function getToggleButton():ToggleButtonController;
	}
}