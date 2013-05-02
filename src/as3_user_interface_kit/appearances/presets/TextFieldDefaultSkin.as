package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.ITextFieldSkin;
	import as3_user_interface_kit.controllers.ScrollBarController;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.VerticalScrollBarView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class TextFieldDefaultSkin implements ITextFieldSkin
	{
		public function TextFieldDefaultSkin()
		{
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getBackgroundImage():View
		{
			var canv:View = new FlexibleImageView(new AstTextFieldCheckbox(), 10, 10);
			return canv;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getAlertBackgroundImage():View
		{
			var canv:View = new FlexibleImageView(new AstTextFieldCheckbox(), 10, 10);
			return canv;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getScrollBar():ScrollBarController
		{
			var v:VerticalScrollBarView = new VerticalScrollBarView(new ScrollBarDefaultSkin());
			var s:ScrollBarController = new ScrollBarController(v);
			s.view.frame.set(0, 0, 15, 15);
			return s;
		}
	}
}