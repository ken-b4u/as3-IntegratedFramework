package as3_user_interface_kit.models
{
	import flash.utils.Dictionary;
	
	import as3_user_interface_kit.controllers.IDeepLinkableViewController;

	public class SceneManager implements ISceneProvider
	{
		public static const INDEX:String = "index";

		private var _scenes:Dictionary;
		private var _numScenes:int = 0;

		public function SceneManager()
		{
			_scenes = new Dictionary();
		}

		public function addScene(scene:IDeepLinkableViewController):void
		{
			_scenes[scene.sceneID] = scene;
			_numScenes++;
		}

		public function getSceneByID(sceneID:String):IDeepLinkableViewController
		{
			if (sceneID == null)
				sceneID = INDEX;
			return _scenes[sceneID];
		}
		
		public function get numScenes():int
		{
			return _numScenes;
		}

	}
}