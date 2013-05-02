package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.IScrollBarViewSkin;
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class ScrollBarDefaultSkin implements IScrollBarViewSkin
	{
		public function ScrollBarDefaultSkin()
		{
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getHandle():View
		{
			var b:ButtonController = new ButtonController(new RectButtonDefaultSkin());
			return b.view;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getUpButton():ButtonController
		{
			var b:ButtonController = new ButtonController(new RectButtonDefaultSkin());
			return b;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getDownButton():ButtonController
		{
			var b:ButtonController = new ButtonController(new RectButtonDefaultSkin());
			return b;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getRail():View
		{
			var skin:View = new FlexibleImageView(new AstTextFieldCheckbox(), 3, 3);
			return skin;
		}
	}
}