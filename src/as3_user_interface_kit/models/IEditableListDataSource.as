package as3_user_interface_kit.models
{

	/**
	 * 行の追加、削除、Drag&amp;Dropでのソートが可能なリストのためのデータ提供をするためのインターフェース.
	 */
	public interface IEditableListDataSource extends ITableViewDataSource
	{
		/**
		 * 該当インデックスにデータを追加します.
		 * @param rowData
		 *
		 */
		function addDataTo( rowData:Object, index:int ):void;

		/**
		 * 該当インデックスのデータを削除します.
		 * @param index
		 *
		 */
		function removeDataAt( index:int ):void;
	}
}