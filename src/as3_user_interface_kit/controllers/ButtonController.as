package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Application;
	import as3_user_interface_kit.Frame;
	
	import as3_user_interface_kit.appearances.IButtonSkin;
	import as3_user_interface_kit.events.ExMouseEvent;
	import as3_user_interface_kit.models.ButtonMode;
	import as3_user_interface_kit.views.View;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event( name = "mouseDownLongTime", type = "as3_user_interface_kit.events.ExMouseEvent" )]
	/**
	 * Button クラスは、コンストラクタに渡される設定クラスからマウスオーバー、アウト、ダウン時のスキンを取得し、
	 * ユーザーの操作に自動でレスポンスを返します。
	 * スキンの表示状態遷移にトランジションを伴う場合には Button クラスを継承し、normal, down, over などのメソッドをオーバーライドします。
	 * @author takanosatoshi
	 *
	 */
	public class ButtonController extends ViewController
	{
		private var _isEnable:Boolean = true;
		/**
		 * @private
		 */
		protected var _normal:View;
		/**
		 * @private
		 */
		protected var _down:View;
		/**
		 * @private
		 */
		protected var _over:View;
		private var _buttonDownFrameCount:int;
		private var _buttonDownTimeThreshould:int;
		private var _isDown:Boolean;
		private var _stage:Stage;

		protected var _icon:View;

		/**
		 * コンストラクタ.
		 * @param スキンを管理する IButtonConfig インスタンス.
		 */
		public function ButtonController( buttonConfig:IButtonSkin )
		{
			_stage = Application.getDocumentClass().stage;
			if ( _stage == null )
				new Error( "Application オブジェクトの initialize メソッドをコールしてください。" );
			super();
			view.buttonMode = true;
			view.mouseEnabled = true;
			view.useHandCursor = true;
			_normal = buttonConfig.getNormalSkin();
			_down = buttonConfig.getDownSkin();
			_over = buttonConfig.getOverSkin();
			view.addChild( _normal );
			if ( _down == null )
				_down = new View();
			if ( _over == null )
				_over = new View();
			view.addChild( _down );
			view.addChild( _over );
			_over.visible = _down.visible = false;
			view.mouseChildren = false;
			_buttonDownFrameCount = 0;
			_buttonDownTimeThreshould = Application.frameRate / 2;
			view.mouseChildren = false;
			_isDown = false;
			
			_icon = new View();
			view.addChild(_icon);
			view.layoutManager.addManagedTarget(_icon, 1, 1);
			view.sizeToFit();
			_icon.mouseEnabled = false;
			_icon.mouseChildren = false;
			
			enableFunc = function():void{
				view.mouseEnabled = true;
			};
			unableFunc = function():void {
				view.mouseEnabled = false;
			};
			normalFunc = function():void {
				if ( !_normal.visible )
				{
					_over.visible = _down.visible = false;
					_normal.visible = true;
					//view.addChild(_normal);
				}
			};
			downFunc = function():void {
				if ( !_down.visible )
				{
					_over.visible = _normal.visible = false;
					_down.visible = true;
					//view.addChild(_down);
				}
			};
			overFunc = function():void {
				if ( !_over.visible )
				{
					_normal.visible = _down.visible = false;
					_over.visible = true;
				//	view.addChild(_over);
				}
			}
		}


		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			view.addEventListener( MouseEvent.ROLL_OVER, rollOverListener );
			view.addEventListener( MouseEvent.ROLL_OUT, rollOutListener );
			view.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener );
			view.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
			_stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
		}


		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			view.removeEventListener( MouseEvent.ROLL_OVER, rollOverListener );
			view.removeEventListener( MouseEvent.ROLL_OUT, rollOutListener );
			view.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener );
			view.removeEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
			_stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
		}


		/**
		 * @inheritDoc
		 * @param mode
		 * @see ButtonMode
		 */
		public function changeState( mode:String ):void
		{
			switch ( mode )
			{
				case ButtonMode.ENABLE:
					_isEnable = true;
					enable();
					break;
				case ButtonMode.UNABLE:
					_isEnable = false;
					unable();
					break;
				case ButtonMode.NORMAL:
					normal();
					break;
				case ButtonMode.DOWN:
					down();
					break;
				case ButtonMode.OVER:
					over();
					break;
			}
		}


		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		public function get isEnable():Boolean
		{
			return _isEnable;
		}


		/**
		 * @inheritDoc
		 * @param w
		 * @param h
		 *
		 */
		override public function viewWillDraw():void
		{
			super.viewWillDraw();
			_normal.frame = _down.frame = _over.frame = new Frame(_normal.x, _normal.y, view.frame.width, view.frame.height );
			_normal.setNeedDisplay();
			_down.setNeedDisplay();
			_over.setNeedDisplay();
		}
		
		private var _enableFunc:Function;

		public function set enableFunc(value:Function):void
		{
			_enableFunc = value;
		}


		private var _unableFunc:Function;

		public function set unableFunc(value:Function):void
		{
			_unableFunc = value;
		}

		
		private var _normalFunc:Function;

		public function set normalFunc(value:Function):void
		{
			_normalFunc = value;
		}

		private var _downFunc:Function;

		public function set downFunc(value:Function):void
		{
			_downFunc = value;
		}

		private var _overFunc:Function;

		public function set overFunc(value:Function):void
		{
			_overFunc = value;
		}


		/**
		 * enable メソッドは changeState メソッドの引数に ButtonMode.ENABLE が渡された時に呼び出されます.
		 * <p>実装は子孫クラスに委譲されます。</p>
		 */
		protected function enable():void
		{
			_enableFunc.call(arguments);
		}


		/**
		 * unable メソッドは changeState メソッドの引数に ButtonMode.UNABLE が渡された時に呼び出されます.
		 * <p>実装は子孫クラスに委譲されます。</p>
		 */
		protected function unable():void
		{
			_unableFunc.call(arguments);
		}


		/**
		 * up メソッドは changeState メソッドの引数に ButtonMode.NORMAL が渡された時に呼び出されます.
		 */
		protected function normal():void
		{
			if (_isEnable)
				_normalFunc.call(arguments);
		}


		/**
		 * down メソッドは changeState メソッドの引数に ButtonMode.DOWN が渡された時に呼び出されます.
		 */
		protected function down():void
		{
			if (_isEnable)
				_downFunc.call(arguments);
		}


		/**
		 * over メソッドは changeState メソッドの引数に ButtonMode.OVER が渡された時に呼び出されます.
		 */
		protected function over():void
		{
			if (_isEnable)
				_overFunc.call(arguments);
		}


		private function rollOverListener( e:MouseEvent ):void
		{
			if ( !_isDown )
				changeState( ButtonMode.OVER );
		}


		private function rollOutListener( e:MouseEvent ):void
		{
			if ( !_isDown )
				changeState( ButtonMode.NORMAL );
		}


		private function mouseDownListener( e:MouseEvent ):void
		{
			changeState( ButtonMode.DOWN );
			Application.getDocumentClass().addEventListener( Event.ENTER_FRAME, enterFrameListener );
			_isDown = true;
		}


		private function mouseUpListener( e:MouseEvent ):void
		{
			if ( !view.getGlobalFrame().contains( Application.getDocumentClass().mouseX, Application.getDocumentClass().mouseY ))
			{
				if ( !_normal.visible )
					changeState( ButtonMode.NORMAL );
			}
			else
			{
				if ( !_over.visible )
					changeState( ButtonMode.OVER );
			}
			if ( Application.getDocumentClass().hasEventListener( Event.ENTER_FRAME ))
				Application.getDocumentClass().removeEventListener( Event.ENTER_FRAME, enterFrameListener );
			_buttonDownFrameCount = 0;
			_isDown = false;
		}


		private function enterFrameListener( e:Event ):void
		{
			_buttonDownFrameCount++;
			if ( _buttonDownFrameCount >= _buttonDownTimeThreshould )
			{
				dispatchEvent( new ExMouseEvent( ExMouseEvent.MOUSE_DOWN_LONG_TIME, false ));
			}
		}


		//////////////////////////////////////////////////////
		//
		public static function createButtonController( container:DisplayObjectContainer, asset:DisplayObject, ButtonControllerClass:Class ):ButtonController
		{
			var x:Number = asset.x;
			var y:Number = asset.y;
			var conf:IButtonSkin = new DynamicButtonConfig( asset );
			var buttonController:ButtonController = new ButtonControllerClass( conf );
			buttonController.view.frame.set( x, y, asset.width, asset.height );
			container.addChild( buttonController.view );
			return buttonController;
		}

		public function get icon():DisplayObject
		{
			return _icon.getChildAt(0);
		}

		public function set icon(value:DisplayObject):void
		{
			if (_icon.numChildren) {
				_icon.removeChild(_icon.getChildAt(0));
			}
			
			if (value) _icon.addChild(value);
			_icon.sizeToFit();
			view.setNeedDisplay();
		}

	}
}
import flash.display.DisplayObject;
import as3_user_interface_kit.appearances.IButtonSkin;
import as3_user_interface_kit.controllers.ButtonController;
import as3_user_interface_kit.views.View;

/**
 * @private
 * @author takanosatoshi
 *
 */
internal class DynamicButtonConfig implements IButtonSkin
{
	private var _view:View;


	public function DynamicButtonConfig( view:DisplayObject )
	{
		_view = new View();
		_view.frame.set( 0, 0, view.width, view.height );
		view.x = view.y = 0;
		_view.addChild( view );
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
