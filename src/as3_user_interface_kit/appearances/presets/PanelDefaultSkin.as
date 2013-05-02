package as3_user_interface_kit.appearances.presets
{
	import flash.display.Shape;
	
	import as3_user_interface_kit.appearances.IPanelSkin;
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class PanelDefaultSkin implements IPanelSkin
	{
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getBackgroundImage():View
		{
			var skin:View = new FlexibleImageView(new AstRoundRectN(), 35, 35);
			return skin;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getCloseButton():ButtonController
		{
			var b:ButtonController = new ButtonController(new RoundRectButtonDefaultSkin());
			var view:View = b.view;
			view.frame.set(0, 0, 18, 18);
			var p:int = 5;
			var s:Shape = new Shape();
			s.graphics.lineStyle(1, 0x333333);
			s.graphics.moveTo(p, p);
			s.graphics.lineTo(view.width - p, view.height - p);
			s.graphics.moveTo(view.width - p, p);
			s.graphics.lineTo(p, view.height - p);
			view.addChild(s);
			return b;
		}
	}
}