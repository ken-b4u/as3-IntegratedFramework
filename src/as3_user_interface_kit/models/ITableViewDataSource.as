package as3_user_interface_kit.models
{
	import flash.events.IEventDispatcher;
	
	import as3_user_interface_kit.controllers.ITableCellController;

/**
 * リストにCell情報を提供するためのインターフェース.
 */
	public interface ITableViewDataSource extends IEventDispatcher
	{
		/**
		 * 引数に渡された index 値の ICellRenderer オブジェクトを返します.
		 * @param index
		 * @return
		 * @see ICellRenderer
		 */
		function cellForRowAt( index:int ):ITableCellController;

		/**
		 * List オブジェクトに必要な行数を返します.
		 * @return
		 *
		 */
		function numberOfRows():int;

		/**
		 * 行の高さを返します.
		 * @return
		 *
		 */
		function getRowHeight(index:int):Number;

	}
}