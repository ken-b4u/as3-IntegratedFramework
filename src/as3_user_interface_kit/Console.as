package as3_user_interface_kit
{
	import as3_foundation.log.IPrintable;
	import as3_foundation.log.LogLevel;
	
	import as3_user_interface_kit.appearances.presets.TextFieldDefaultSkin;
	import as3_user_interface_kit.controllers.TextFieldController;
	import as3_user_interface_kit.filters.TextFormatFilter;
	import as3_user_interface_kit.models.ClonableTextFormat;
	import as3_user_interface_kit.models.FLUITextFormat;
	import as3_user_interface_kit.views.TextFieldView;
	
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Console implements IPrintable
	{
		private static var _consoleHeight:Number = 100;
		private static var _instance:Console;
		private var _tf:TextFieldController;
		private var _filters:Array;

		/**
		 * @private
		 * @param si
		 *
		 */
		public function Console(si:SingletonEnforcer)
		{
			var filters:Array = new Array();
			filters.push(new TextFormatFilter(LogLevel.getModeString(LogLevel.DEBUG), new TextFormat("_sans", 14, 0x00ff00)));
			filters.push(new TextFormatFilter(LogLevel.getModeString(LogLevel.INFO), new TextFormat("_sans", 14, 0x33ccff)));
			filters.push(new TextFormatFilter(LogLevel.getModeString(LogLevel.WARN), new TextFormat("_sans", 14, 0xffff00)));
			filters.push(new TextFormatFilter(LogLevel.getModeString(LogLevel.ERROR), new TextFormat("_sans", 14, 0xff0000)));
			_tf = new ConsoleTextFieldController(new TextFieldDefaultSkin(), new TextFieldView(filters));
			
			var fmt:ClonableTextFormat = FLUITextFormat.instance().getLabelTextFormat().clone();
			_tf.textField.defaultTextFormat = fmt;
			_tf.multiline = true;
			Application.getDocumentClass().stage.addChild(_tf.view);
			Application.getDocumentClass().stage.addEventListener(Event.RESIZE, resize);
			_tf.view.backgroundImage.transform.colorTransform = new ColorTransform(0, 0, 0);
			_tf.view.backgroundImage.alpha = 0.7;
			_tf.fontType = "_sans";
			_tf.fontSize = 14;
			_tf.textField.type = TextFieldType.DYNAMIC;
			_tf.placeholder = "";
			_tf.color = 0x00ff00;

			resize(null);
		}
		
		public function clear():void
		{
			_tf.text = "";
		}

		private function resize(e:Event):void
		{
			var f:Frame = Application.applicationFrame;
			_tf.view.frame.set(0, f.height - _consoleHeight, f.width, _consoleHeight);
			_tf.view.setNeedDisplay();
		}

		public function get consoleHeight():Number
		{
			return _consoleHeight;
		}

		public function set consoleHeight(val:Number):void
		{
			_consoleHeight = val;
			resize(null);
		}

		public function destroy():void
		{
			Application.getDocumentClass().stage.removeChild(_tf.view);
			Application.getDocumentClass().stage.removeEventListener(Event.RESIZE, resize);
			_tf = null;
			_instance = null;
		}

		public static function instance():Console
		{
			if (_instance == null)
				_instance = new Console(new SingletonEnforcer());
			return _instance;
		}

		public function print(characters:String):void
		{
			_tf.text += characters + "\n";
		}

	}
}

import as3_user_interface_kit.appearances.ITextFieldSkin;
import as3_user_interface_kit.controllers.TextFieldController;
import as3_user_interface_kit.views.AbstractTextFieldView;

/**
 * @private
 * @author tkn
 *
 */
internal class SingletonEnforcer
{
}

internal class ConsoleTextFieldController extends TextFieldController
{
	public function ConsoleTextFieldController(config:ITextFieldSkin, textView:AbstractTextFieldView)
	{
		super(config, textView);
	}
	
	override public function focusIn():void
	{
		
	}
	
	override public function focusOut():void
	{
		
	}
	
}