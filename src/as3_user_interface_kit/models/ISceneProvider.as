package as3_user_interface_kit.models
{
	import as3_user_interface_kit.controllers.IDeepLinkableViewController;

	/**
	 * 主に<code>DeepLinkNavigationController</code>のデータソースとなる為に実装が必要なインターフェースです。
	 * <code>DeepLinkNavigationController</code>は、<code>SWFAddressEvent.CHANGE</code>を監視していて、
	 * イベント発生時に<code>SWFAddressEvent.getPathNames()</code>の最後に入っているパラメータをシーンIDとして、
	 * <code>ISceneProvider.getSceneByID</code>を呼び出します。
	 * この時<code>ISceneProvider.getSceneByID</code>を実装したクラスで適切な<code>IViewController</code>を返せば、
	 * シーン管理の手間が大幅に節約できます。</br>
	 * 
	 * 
	 * @author tkn
	 * @see IViewController
	 */	
	public interface ISceneProvider
	{
		function addScene(scene:IDeepLinkableViewController):void;
		
		/**
		 * 渡された文字列IDに応じて、<code>IViewController</code>インスタンスを返します. 
		 * @param id
		 * @return 
		 * 
		 */		
		function getSceneByID(id:String):IDeepLinkableViewController;
		
		/**
		 * シーンの数. 
		 * @return 
		 * 
		 */		
		function get numScenes():int;
	}
}