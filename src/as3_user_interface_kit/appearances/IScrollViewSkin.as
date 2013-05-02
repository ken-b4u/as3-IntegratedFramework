package as3_user_interface_kit.appearances
{
	import as3_user_interface_kit.controllers.ScrollBarController;

	/**
	 * <code>ScrollViewController</code>クラスの設定用インターフェース.
	 * @see as3_user_interface_kit.controllers.ScrollViewController
	 */
	public interface IScrollViewSkin
	{
		/**
		 * スクロールバービューを返します.
		 * @return
		 * @see as3_user_interface_kit.controllers.ScrollBarController
		 */
		function getScrollBar():ScrollBarController;
	}
}