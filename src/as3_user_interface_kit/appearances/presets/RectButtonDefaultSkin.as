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
	public class RectButtonDefaultSkin implements IButtonSkin
	{
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getNormalSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectN(), 2, 2);
			return skin;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getDownSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectD(), 2, 2);
			return skin;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function getOverSkin():View
		{
			var skin:View = new FlexibleImageView(new AstRectO(), 2, 2);
			return skin;
		}
	}
}