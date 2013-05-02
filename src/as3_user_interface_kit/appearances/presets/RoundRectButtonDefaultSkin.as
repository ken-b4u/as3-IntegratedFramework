package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.IButtonSkin;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.View;

	/**
	 * モック作成用.
	 * <p>ビューコンポーネントをデザイン無しで実装するためのデフォルトコンフィグ</p>
	 * @author tkn
	 *
	 */
	public class RoundRectButtonDefaultSkin implements IButtonSkin
	{

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getNormalSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRoundRectN(), 4, 4);
			return skin;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getDownSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRoundRectD(), 4, 4);
			return skin;
		}

		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getOverSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRoundRectO(), 4, 4);
			return skin;
		}
	}
}