package as3_user_interface_kit.models
{
	import flash.text.TextFormat;
	


	/**
	 * ComponentElement オブジェクトで共通して使用されるテキストフォーマット.
	 * @param si
	 *
	 */
	public class FLUITextFormat
	{
		private static var _instance:FLUITextFormat;
		private var _isInitialized:Boolean;
		private var _default:TextFormat;

		private var _defaultLabelFormat:ClonableTextFormat;
		private var _defaultInputFormat:ClonableTextFormat;

		/**
		 * @private
		 */
		public function FLUITextFormat(si:SingletonEnforcer)
		{
			_default = new ClonableTextFormat("_sans", 12, 0x444444);
			_defaultLabelFormat = new ClonableTextFormat("_sans", 12, 0x444444);
			_defaultInputFormat = new ClonableTextFormat("_sans", 12, 0x444444);
		}

		/**
		 *　オブジェクトを返します.
		 * @return
		 *
		 */
		public static function instance():FLUITextFormat
		{
			if (!_instance)
			{
				_instance = new FLUITextFormat(new SingletonEnforcer());
			}
			return _instance;
		}

		/**
		 * ラベルに使用されるClonableTextFormatオブジェクトを返します.
		 * @return
		 *
		 */
		public function getLabelTextFormat():ClonableTextFormat
		{
			return _defaultLabelFormat.clone();
		}

		/**
		 * ラベルに使用されるClonableTextFormatオブジェクトを設定します.
		 * @param fmt
		 *
		 */
		public function setLabelTextFormat(fmt:ClonableTextFormat):void
		{
			_defaultLabelFormat = fmt;
		}

		/**
		 * テキスト入力に使用されるClonableTextFormatオブジェクトを返します.
		 * @return
		 *
		 */
		public function getInputTextFormat():ClonableTextFormat
		{
			return _defaultInputFormat.clone();
		}

		/**
		 * テキスト入力に使用されるClonableTextFormatオブジェクトを設定します.
		 * @param fmt
		 *
		 */
		public function setInputTextFormat(fmt:ClonableTextFormat):void
		{
			_defaultInputFormat = fmt;
		}
	}
}

internal class SingletonEnforcer
{
}