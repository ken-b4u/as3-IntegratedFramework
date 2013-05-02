package as3_user_interface_kit.appearances.presets
{
	import as3_user_interface_kit.appearances.ISliderSkin;
	import as3_user_interface_kit.controllers.ButtonController;
	import as3_user_interface_kit.views.FlexibleImageView;
	import as3_user_interface_kit.views.View;
	
	public class SliderDefaultSkin implements ISliderSkin
	{
		public function SliderDefaultSkin()
		{
		}
		
		public function getHandle():View
		{
			var button:ButtonController = new ButtonController(new RectButtonDefaultSkin());
			button.view.frame.set(0, 0, 20, 20);
			return button.view;
		}
		
		public function getRail():View
		{
			var rail:View = new FlexibleImageView(new AstTextFieldCheckbox(), 3, 3);
			rail.frame.set(0, 0, 5, 5);
			return rail;
		}
	}
}