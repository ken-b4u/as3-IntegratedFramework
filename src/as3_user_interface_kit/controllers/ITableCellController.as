package as3_user_interface_kit.controllers
{
	import flash.display.DisplayObject;
	
	import as3_foundation.Indexable;

	/**
	 * @author takanosatoshi
	 */
	public interface ITableCellController extends IViewController, Indexable
	{
		/**
		 * データ.
		 * @return
		 */
		function get cellData():Object;
		function set cellData(data:Object):void;
		
		function get contentView():DisplayObject;
		function set contentView(view:DisplayObject):void;
	}
}
