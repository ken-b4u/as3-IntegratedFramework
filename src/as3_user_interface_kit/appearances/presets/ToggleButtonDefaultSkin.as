package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.IToggleButtonSkin;
	import as3_user_interface_kit.views.DrawableView;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class ToggleButtonDefaultSkin extends RoundRectButtonDefaultSkin implements IToggleButtonSkin
	{	
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function getNormalSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectN(), 2, 2);
			return skin;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function getDownSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectD(), 2, 2);
			return skin;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function getOverSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectO(), 2, 2);
			return skin;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getOnIcon():View
		{
			var v:DrawableView = new DrawableView(0x666666, 0x666666);
			v.frame.set(0, 0, 5, 5);
			return v;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getOffIcon():View
		{
			var v:DrawableView = new DrawableView();
			v.visible = false;
			v.alpha = 0;
			return v;
		}
	}
}