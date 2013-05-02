package as3_user_interface_kit
{
	import as3_user_interface_kit.controllers.ViewController;
	import as3_user_interface_kit.views.View;
	
	import flash.events.Event;
	
	/**
	 * ドキュメントクラスのベースとなるクラスです.
	 * @author tkn
	 *
	 */
	public class DocumentClassBase extends as3_user_interface_kit.views.View
	{
		public function DocumentClassBase()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.ENTER_FRAME, stageCheck);
		}
		
		private function stageCheck(e:Event):void
		{
			if (stage.stageWidth && stage.stageHeight)
			{
				removeEventListener(Event.ENTER_FRAME, stageCheck);
				Application.initialize(this);
				prepared();
			}
		}
		
		/**
		 * もろもろの前作業が終わったときに呼び出されます.
		 * <p>アプリケーション毎に固有の処理はここから開始します。</p>
		 */
		protected function prepared():void
		{
			throw new Error("DocumentClass のサブクラスで prepared メソッドをオーバーライドする必要があります.");
		}
		
		public function get appViewController():ViewController
		{
			return Application.globalViewController;
		}
		
		public function get appView():View
		{
			return Application.globalViewController.view;
		}
		
		/**
		 * FlashVars を返します.
		 * @return
		 *
		 */
		public function getFlashVars():Object
		{
			return this.root.loaderInfo.parameters;
		}
		
	}
}