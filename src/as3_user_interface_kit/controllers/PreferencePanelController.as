package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.appearances.presets.PanelDefaultSkin;
	import as3_user_interface_kit.views.DrawableView;
	import as3_user_interface_kit.views.View;

	public class PreferencePanelController extends ResizablePanelController
	{
		public function PreferencePanelController()
		{
			super(new PanelDefaultSkin());
			
			view.frame.set(0, 0, 200, 200);
		}
		
	}
}