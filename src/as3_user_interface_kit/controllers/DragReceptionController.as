package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Frame;

	/**
	 * アイテムの受け入れ先.
	 * @see DragItem
	 */
	public class DragReceptionController extends ViewController
	{
		private var _items:Array;

		/**
		 * コンストラクタ.
		 */
		public function DragReceptionController()
		{
			_items = [];
		}

		/**
		 * 受け入れコンテナにオブジェクトを追加します.
		 * @param substance
		 * @return
		 * @see DragItem
		 */
		public function addItem(item:IDraggableViewController):void
		{
			item.reception = this;
			_items.push(item);
		}

		/**
		 * 受け入れコンテナからオブジェクトを削除します.
		 * @param substance
		 * @return
		 * @see DragItem
		 */
		public function removeItem(item:IDraggableViewController):void
		{
			item.reception = null;
			for (var i:int = 0; i < _items.length; i++)
			{
				var itm:IDraggableViewController = _items[i];
				if (itm == item)
				{
					_items.splice(i, 1);
				}
			}
		}

		/**
		 * 受け入れコンテナの childIndex に従ってオブジェクトを返します.
		 * @param idx
		 * @return
		 * @see DragItem
		 */
		public function getItemAt(idx:int):IDraggableViewController
		{
			return _items[idx];
		}

		/**
		 * 引数に渡されたオブジェクトが受け入れ可能かどうかを返します.
		 * @param item
		 * @return
		 * @see DragItem
		 */
		public function canAccept(item:IDraggableViewController):Boolean
		{
			var frm1:Frame = view.getGlobalFrame();
			var frm2:Frame = item.ghost.getGlobalFrame();

			return frm1.intersects(frm2);
		}

		/**
		 * 保有しているオブジェクトの個数を返します.
		 * @return
		 *
		 */
		public function get itemLength():int
		{
			return _items.length;
		}

		/**
		 * 受け入れコンテナに配置されているオブジェクトを全て含んだ配列を返します.
		 * @return
		 *
		 */
		public function getAllItem():Array
		{
			return _items;
		}
	}
}