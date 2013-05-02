package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.IDropdownListSkin;
	import as3_user_interface_kit.controllers.ToggleButtonController;
	import as3_user_interface_kit.views.AbstractLabel;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.Label;
	import as3_user_interface_kit.views.VerticalScrollBarView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class DropdownListDefaultSkin implements IDropdownListSkin
	{
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getScrollBarView():VerticalScrollBarView
		{
			var v:VerticalScrollBarView = new VerticalScrollBarView(new ScrollBarDefaultSkin());
			v.frame.set(0, 0, 20, 20);
			return v;
		}

		public function getPlaceholder():AbstractLabel
		{
			// aa
			var label:Label = new Label();
			label.sizeToFit();
			return label;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getRootRow():View
		{
			var v:View = new FlexibleImageView(new AstRectN(), 2, 2);
			return v;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getToggleButton():ToggleButtonController
		{
			var c:ToggleButtonController = new ToggleButtonController(new ToggleButtonDefaultSkin());
			c.view.frame.set(0, 0, 30, 30);
			return c;
		}
	}
}