package as3_user_interface_kit.controllers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3_user_interface_kit.appearances.IToggleButtonSkin;
	import as3_user_interface_kit.views.View;
	
	[Event( name = "change", type = "flash.events.Event" )]
	/**
	 * トグルボタン.
	 * <p><code>ToggleButtonController</code>はマウスクリック時に、ON/OFFの状態変更、状態に応じた外見に変化します。</p>
	 * @author tkn
	 *
	 */
	public class ToggleButtonController extends ButtonController
	{
		protected var _onSkin:View;
		protected var _offSkin:View;
		private var _isOn:Boolean;
		
		
		/**
		 * コンストラクタ.
		 * @param config
		 *
		 */
		public function ToggleButtonController( config:IToggleButtonSkin )
		{
			super( config );
			_onSkin = config.getOnIcon() || new View();
			_offSkin = config.getOffIcon() || new View();
			
			/*view.layoutManager.addManagedTarget( _onSkin, 1, 1 );
			view.layoutManager.addManagedTarget( _offSkin, 1, 1 );*/
			_onSkin.buttonMode = _offSkin.buttonMode = true;
			view.addChild(_onSkin);
			view.addChild(_offSkin);
			_isOn = true;
			off();
			
			normalFunc = function():void {
				if (isOn) {
					_offSkin.visible = _normal.visible = _over.visible = _down.visible = false;
					_onSkin.visible = true;
				}
				else {
					_onSkin.visible = _normal.visible = _over.visible = _down.visible = false;
					_offSkin.visible = true;
				}
			};
		}
		
		
		/**
		 * @inheritDoc
		 *
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			view.addEventListener( MouseEvent.CLICK, clickListener );
		}
		
		
		/**
		 * @inheritDoc
		 *
		 */
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			view.removeEventListener( MouseEvent.CLICK, clickListener );
		}
		
		
		/**
		 * on.
		 *
		 */
		public function on():void
		{
			if ( _isOn )
				return;
			_isOn = true;
			_offSkin.visible = _normal.visible = _over.visible = _down.visible = false;
			_onSkin.visible = true;
			dispatchEvent( new Event( Event.CHANGE ));
		}
		
		
		/**
		 * off.
		 *
		 */
		public function off():void
		{
			if ( !_isOn )
				return;
			_isOn = false;
			_onSkin.visible = _normal.visible = _over.visible = _down.visible = false;
			_offSkin.visible = true;
			dispatchEvent( new Event( Event.CHANGE ));
		}
		
		
		/**
		 * ボタンが ON になっているかどうか.
		 * @return
		 *
		 */
		public function get isOn():Boolean
		{
			return _isOn;
		}
		
		
		private function clickListener( e:MouseEvent ):void
		{
			if ( isOn )
				off();
			else
				on();
		}
		
		
		public static function createToggleButtonController( container:DisplayObjectContainer, onIcon:Sprite, offIcon:Sprite, ToggleButtonControllerClass:Class ):ToggleButtonController
		{
			var x:Number = onIcon.x;
			var y:Number = offIcon.y;
			var conf:IToggleButtonSkin = new DynamicToggleButtonConfig( onIcon, offIcon );
			var buttonController:ToggleButtonController = new ToggleButtonControllerClass( conf );
			buttonController.view.frame.set( x, y, onIcon.width, offIcon.height );
			container.addChild( buttonController.view );
			return buttonController;
		}
	}
}
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

import as3_user_interface_kit.appearances.IButtonSkin;
import as3_user_interface_kit.appearances.IToggleButtonSkin;
import as3_user_interface_kit.controllers.ButtonController;
import as3_user_interface_kit.controllers.ToggleButtonController;
import as3_user_interface_kit.views.View;

/**
 * @private
 * @author takanosatoshi
 *
 */
internal class DynamicButtonConfig implements IButtonSkin
{
	private var _view:View;
	public function DynamicButtonConfig(view:Sprite)
	{
		_view = new View();
		_view.addChild(view);
		_view.sizeToFit();
	}
	
	
	public function getNormalSkin():View
	{
		return _view;
	}
	
	
	public function getDownSkin():View
	{
		return null;
	}
	
	
	public function getOverSkin():View
	{
		return null;
	}
}

internal class DynamicToggleButtonConfig extends DynamicButtonConfig implements IToggleButtonSkin
{
	private var _view:View;
	private var _on:View;
	private var _off:View;
	public function DynamicToggleButtonConfig(on:Sprite, off:Sprite)
	{
		super( new View() );
		
		_on = new View();
		_on.addChild(on);
		_on.sizeToFit();
		_on.frame.origin = new Point(on.x, on.y);
		_off = new View();
		_off.addChild(off);
		_off.sizeToFit();
		_off.frame.origin = new Point(off.x, off.y);
	}
	
	
	public function getOnIcon():View
	{
		return _on;
	}
	
	
	public function getOffIcon():View
	{
		return _off;
	}
}
