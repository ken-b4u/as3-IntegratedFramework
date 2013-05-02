package as3_user_interface_kit
{
	import flash.display.Sprite;

	/**
	 * <code>FocusManager</code>のフォーカス制御対象として登録するために必要なインターフェースです.
	 */
	public interface IFocusable
	{
		/**
		 * フォーカスが入った時に呼び出されます.
		 * <p>このメソッドは<code>FocusManager</code>の管理対象として登録されている時に、<br/>
		 * <code>FocusManager</code>から呼び出されます.</p>
		 */
		function focusIn():void;

		/**
		 * フォーカスが外れた時に呼び出されます.
		 * <p>このメソッドは<code>FocusManager</code>の管理対象として登録されている時に、<br/>
		 * <code>FocusManager</code>から呼び出されます.</p>
		 */
		function focusOut():void;
		
		/**
		 * 実際にフォーカスの対象となる<code>Sprite</code>インスタンスです. 
		 * @return 
		 * 
		 */		
		function get focusTarget():Sprite;
	}
}