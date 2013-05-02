package as3_user_interface_kit.controllers
{
	import flash.display.DisplayObject;
	
	import as3_user_interface_kit.views.View;

	/**
	 * リストビューコンポーネントに使用する行コンポーネントです.
	 * <p>リスト内での行として振舞うメソッドを実装しています。行内にイメージを表示させるなど、
	 * アプリケーション固有の外見を構築するには<code>cellData</code>プロパティのsetterをオーバーライドして、
	 * 引数に渡された<code>Object</code>型のデータに応じた処理をします。</p>
	 * @author takanosatoshi
	 *
	 */
	public class TableCellController extends ViewController implements ITableCellController
	{
		private var _selected:Boolean = false;
		private var _index:int;
		private var _obj:Object;
		private var _contentView:DisplayObject;

		/**
		 * コンストラクタ.
		 * @param skin
		 */
		public function TableCellController(skin:View)
		{
			super();

			view.backgroundImage = skin;
			skin.useHandCursor = false;
		}

		/**
		 * この行のリスト内でのインデックス.
		 * @return
		 *
		 */
		public function get index():int
		{
			return _index;
		}

		public function set index(index:int):void
		{
			_index = index;
		}

		/**
		 * @inheritDoc
		 */
		public function get cellData():Object
		{
			return _obj;
		}

		public function set cellData(data:Object):void
		{
			_obj = data;
		}

		public function get contentView():DisplayObject
		{
			return _contentView;
		}

		public function set contentView(value:DisplayObject):void
		{
			if (_contentView) view.removeChild(_contentView);
			_contentView = value;
			view.addChild(_contentView);
		}


	}
}