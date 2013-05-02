package as3_user_interface_kit.views
{
	import as3_user_interface_kit.Frame;
	import as3_foundation.IInsistence;
	
	import as3_user_interface_kit.Grid9Layout;
	import as3_user_interface_kit.controllers.IViewController;
	import as3_user_interface_kit.events.ViewControllerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * View クラスは、ボタン、スクロール領域、スクロールバー、リストなど汎用コンポーネントを扱う ViewController の表示部分を分離したクラスです.
	 * <p>View（またはそのサブクラス）オブジェクトと ViewController（またはそのサブクラス）オブジェクトは常にペアで使用されます<br />
	 * DisplayObject の x, y, width, height を直接操作の代替としてサイズ,座標管理のために、Frame オブジェクトのプロパティを持っています。
	 * frame プロパティの width, height, origin.x, origin.y, center.x, center.y を使用することで、フレキシブルな座標、サイズ管理が可能になります。
	 * 実際に、DisplayObject の x, y に反映するのは、プロテクテッドメソッドとして用意されている draw メソッドになります。
	 * View のサブクラスでは、自身のサイズ設定や、自身の表示リストに存在する表示オブジェクトの座標、サイズ設定を draw メソッドの中で行います。
	 * クライアントが使用するときは、frame プロパティの値を変更した後、frame プロパティを再代入するか setNeedDisplay メソッドを使用して表示更新を要求します。</p>
	 *
	 * @author takanosatoshi
	 * @see ViewController
	 */
	public class View extends Sprite implements IInsistence
	{
		private var _frame:Frame;
		private var _layoutManager:Grid9Layout;
		private var _controller:IViewController;
		private var _wasAddToStage:Boolean;
		private var _wasActivated:Boolean;
		private var _backgroundImage:View;
		public var tag:int;

		public function View()
		{
			this.focusRect = false;
			this.tabEnabled = false;
			_wasActivated = false;
			_wasAddToStage = false;

			controller = new DefaultViewController();

			_layoutManager = new Grid9Layout(this);

			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, true);
			
			_frame = new Frame();
		}
		
		/**
		 * <code>DisplayObject.addChild</code>をオーバーライドしています.
		 * <p>実際に<code>child</code>が表示ツリーに追加される直前に、<code>controller</code>の<code>viewWillAppear</code>をコールします。</p>
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var view:View = child as View;
			if (view) view.controller.viewWillAppear();
			super.addChild(child);
			return child;
		}
		
		/**
		 * <code>DisplayObject.removeChild</code>をオーバーライドしています.
		 * <p>実際に<code>child</code>が表示ツリーから削除される直前に、<code>controller</code>の<code>viewWillDisappear</code>をコールします。</br>
		 * <code>controller</code>は<code>viewWillDisappear</code>での処理（アニメーションなど）が終わって、<code>view</code>が表示ツリーから削除されてもよくなった時に、</br>
		 * <code>ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY</code>をディスパッチする必要があります。</p>
		 * 
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var view:View = child as View;
			if (view) {
				view.controller.addEventListener(ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY, function(e:Event):void{
					var cont:IViewController = e.target as IViewController;
					cont.removeEventListener(ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY, arguments.callee);
					removeFromSuper(cont.view);	
				});
				view.controller.viewWillDisappear();
			}
			else super.removeChild(child);
			return child;
		}
		
		private function removeFromSuper(child:DisplayObject):void{
				super.removeChild(child);
		}
		
		override public function get x():Number
		{
			return _frame.x;
		}
		
		override public function set x(value:Number):void
		{
			value = value << 0;
			super.x = value;
			_frame.x = value;
		}
		
		override public function get y():Number
		{
			return _frame.y;
		}
		
		override public function set y(value:Number):void
		{
			value = value << 0;
			super.y = value;
			_frame.y = value;
		}
		
		override public function get width():Number
		{
			return _frame.width;
		}
		
		override public function set width(value:Number):void
		{
			_frame.width = value;
		}
		
		override public function get height():Number
		{
			return _frame.height;
		}
		
		override public function set height(value:Number):void
		{
			_frame.height = value;
		}
		
		// debug
		/*public function get realWidth():Number
		{
			return super.width;
		}
		
		public function get realHeight():Number
		{
			return super.height;
		}*/

		/**
		 * 位置、サイズを保持する Frame オブジェクト.
		 * @return
		 *
		 */
		public function get frame():Frame
		{
			return _frame;
		}

		public function set frame(frame:Frame):void
		{
			_frame = frame;
			/*super.x = _frame.x;
			super.y = _frame.y;*/
			// ステージに追加されていたら有効フラグ立てて描画する
			if (_wasAddToStage)
			{
				_wasActivated = true;
				draw();
			}
		}
		
		/**
		 * この view のグローバル座標系に関する<code>Frame</code>インスタンスを返します. 
		 * @return 
		 * 
		 */		
		public function getGlobalFrame():Frame
		{
			var frm:Frame = frame.clone() as Frame;
			var global:Point = getGlobalCoordinate();
			frm.x = global.x;
			frm.y = global.y;
			return frm;
		}

		/**
		 * 表示更新を要求します.
		 *
		 */
		public function setNeedDisplay():void
		{
			if (_wasActivated)
			{
				_controller.viewWillDraw();
				draw();
			}
		}
		
		public function setNeedDisplayAtExitFrame():void {
			if (wasActivated) {
				addEventListener(Event.EXIT_FRAME, function():void {
					_controller.viewWillDraw();
					draw();
					removeEventListener(Event.EXIT_FRAME, arguments.callee);
				});
			}
		}

		/**
		 * frame プロパティの幅と高さを、このオブジェクトの表示ツリーに存在しているオブジェクトにフィットしたサイズに設定します.
		 */
		public function sizeToFit():void
		{
			if (_frame != null)
			{
				 var len:int = numChildren;
				var maxWidth:Number = 0;
				var maxHeight:Number = 0;
				for (var i:int = 0; i < len; i++)
				{
					var child:DisplayObject = getChildAt(i);
					maxWidth = Math.max(maxWidth, child.width + child.x);
					maxHeight = Math.max(maxHeight, child.height + child.y);
				}
				//trace("sizetoFit",maxWidth, maxHeight);
				frame.width = maxWidth;
				frame.height = maxHeight; 
			}
			/*frame.width = super.width;
			frame.height = super.height;*/
		}

		public function get layoutManager():Grid9Layout
		{
			return _layoutManager;
		}

		/**
		 * このメソッドの中で、frame プロパティの各パラメータを実際の座標や幅、高さに反映します.
		 * <p>View のサブクラスで、DisplayObject.x、DisplayObject.y 座標の操作をする時は、
		 * このメソッドの中で行います。<br />
		 * draw メソッドの外から表示をすぐに更新したい時はなるべく x, y 座標を直接操作せずに、setNeedDisplay メソッドを呼び出します.<br/></p>
		 */
		protected function draw():void
		{
			super.x = _frame.x << 0;
			super.y = _frame.y << 0;

			if (_backgroundImage)
			{
				_backgroundImage.frame.width = frame.width;
				_backgroundImage.frame.height = frame.height;
				_backgroundImage.setNeedDisplay();
			}

			_layoutManager.update();
		}

		/**
		 * このオブジェクトのステージ上での座標を返します.
		 *
		 */
		public function getGlobalCoordinate():Point
		{
			var tmpX:Number = 0;
			var tmpY:Number = 0;
			var _parent:DisplayObject = this;
			while (1)
			{
				if (!_parent)
					break;
				tmpX += _parent.x;
				tmpY += _parent.y;
				_parent = _parent.parent;
			}

			return new Point(tmpX, tmpY);
		}

		/**
		 * 引数に渡された<code>DisplayObjectContainer</code>オブジェクト上での座標を返します. 
		 * @param target
		 * @return 
		 * 
		 */		
		public function getCoordinateIn(target:DisplayObjectContainer):Point
		{
			var global:Point = getGlobalCoordinate();

			var tmpX:Number = global.x;
			var tmpY:Number = global.y;

			var _parent:DisplayObject = target;
			while (1)
			{
				if (!_parent)
					break;
				tmpX -= _parent.x;
				tmpY -= _parent.y;
				_parent = _parent.parent;
			}

			return new Point(tmpX, tmpY);
		}
		
		private function addedToStage(e:Event):void
		{
			_wasAddToStage = true;
			
			// ステージ上に有り、かつ frame プロパティを持っていたら
			if (_frame != null)
				_wasActivated = true;
			_controller.viewDidAppear();
			setNeedDisplay();
		}

		private function removeFromStage(e:Event):void
		{
			_wasAddToStage = false;
			_wasActivated = false;
			_controller.viewDidDisappear();
		}

		/**
		 * この View オブジェクトの IViewController です.
		 */
		public function get controller():IViewController
		{
			return _controller;
		}

		public function set controller(controller:IViewController):void
		{
			_controller = controller;
			if (_controller.view != this)
				_controller.view = this;
		}

		/**
		 * View の表示が更新可能かどうかの真偽値です.
		 */
		public function get wasActivated():Boolean
		{
			return _wasActivated;
		}

		/**
		 * @inheritDoc
		 */
		public function get className():String
		{
			return getQualifiedClassName(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get classObject():Class
		{
			return getDefinitionByName(className) as Class;
		}

		/**
		 * 背景イメージです.
		 */
		public function get backgroundImage():View
		{
			return _backgroundImage;
		}

		public function set backgroundImage(backgroundImage:View):void
		{
			if (_backgroundImage != null)
			{
				removeChild(_backgroundImage);
				return;
			}
			_backgroundImage = backgroundImage;
			addChildAt(_backgroundImage, 0);
		}
	}
}

import flash.events.Event;
import flash.events.EventDispatcher;

import as3_user_interface_kit.controllers.IViewController;
import as3_user_interface_kit.controllers.NavigationController;
import as3_user_interface_kit.events.ViewControllerEvent;
import as3_user_interface_kit.views.View;

internal class DefaultViewController extends EventDispatcher implements IViewController
{
	private var _view:View;

	public function DefaultViewController()
	{
	}
	
	public function get viewCanRemove():Boolean{
		return true;
	}

	public function get view():View
	{
		return _view
	}

	public function set view(view:View):void
	{
		_view = view;
	}

	public function viewWillAppear():void
	{
	}

	public function viewDidAppear():void
	{
		_view.setNeedDisplay();
	}

	public function viewWillDisappear():void
	{
		dispatchEvent(new ViewControllerEvent(ViewControllerEvent.VIEW_CAN_REMOVE_FROM_DISPLAY));
	}

	public function viewDidDisappear():void
	{		
	}

	public function viewWillDraw():void
	{
	}

	public function get navigationController():NavigationController
	{
		return null
	}

	public function set navigationController(navigationController:NavigationController):void
	{
	}

	public function get parentViewController():IViewController
	{
		return null
	}

	public function set parentViewController(viewController:IViewController):void
	{
	}

	public function get className():String
	{
		return "DummyViewController";
	}

	public function get classObject():Class
	{
		return null;
	}
}