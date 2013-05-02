package as3_user_interface_kit.controllers
{
	import as3_foundation.IInsistence;
	
	import as3_user_interface_kit.views.View;
	
	import flash.events.IEventDispatcher;

	/**
	 * <code>IViewController</code>インターフェースは<code>View</code>のコントローラであることを示すインタフェースを提供します.
	 * <p>このインタフェースをimplementsしたクラスは、<code>View</code>が表示リストに追加される、または表示リスト削除されるタイミングで呼び出されるメソッドを実装します.</p>
	 * @see ViewController
	 * @author takanosatoshi
	 */
	public interface IViewController extends IEventDispatcher, IInsistence
	{
		/**
		 * ビューが表示ツリーに追加される直前に呼び出されます.
		 * <p><code>view</code>プロパティの表示ツリー上の親が<code>View</code>インスタンスでない場合このメソッドは呼ばれません。</p>
		 */
		function viewWillAppear():void;

		/**
		 * ビューが表示ツリーに追加された直後に呼び出されます.
		 * <p>このメソッド内でイベントリスナの登録などを行います。</p>
		 */
		function viewDidAppear():void;

		/**
		 * ビューが表示ツリーから削除される直前に呼び出されます.
		 * <p><code>view</code>プロパティの表示ツリー上の親が<code>View</code>インスタンスでない場合このメソッドは呼ばれません。</p>
		 */
		function viewWillDisappear():void;

		/**
		 * ビューが表示ツリーから削除された直後に呼び出されます.
		 * <p>このメソッド内でイベントリスナの削除などを行います。</p>
		 */
		function viewDidDisappear():void;

		/**
		 * ビューが更新される直前に呼び出されます.
		 */
		function viewWillDraw():void;

		/**
		 * ビュー.
		 */
		function get view():View;
		function set view(view:View):void;

		/**
		 * <code>NavigationController</code>インスタンス.
		 * @return
		 * @see NavigationController
		 */
		function get navigationController():NavigationController;
		function set navigationController(navigationController:NavigationController):void;

		/**
		 * 1階層上の<code>IViewController</code>インスタンス.
		 * @return
		 *
		 */
		function get parentViewController():IViewController;
		function set parentViewController(viewController:IViewController):void;
	}
}
