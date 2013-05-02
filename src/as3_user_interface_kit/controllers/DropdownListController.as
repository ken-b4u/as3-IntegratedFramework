package as3_user_interface_kit.controllers
{
	import as3_animation_kit.IEasing;
	import as3_animation_kit.NumericalInterpolator;
	import as3_animation_kit.interpolator.RPSine;
	
	import as3_user_interface_kit.Application;
	import as3_user_interface_kit.Frame;
	import as3_user_interface_kit.appearances.IDropdownListSkin;
	import as3_user_interface_kit.models.ITableViewDataSource;
	import as3_user_interface_kit.views.AbstractLabel;
	import as3_user_interface_kit.views.ScrollView;
	import as3_user_interface_kit.views.View;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ドロップダウンリスト です.
	 *
	 * <p><code>DropdownListController</code>クラスは、内部に<code>TableController</code>を保持し、<br/>
	 * リストの開閉を自動で行います。<br/>
	 * <code>TableController</code>と同じように,dataSource を必要とします。</p>
	 * @author tkn
	 *
	 */
	public class DropdownListController extends ViewController
	{
		private var _tableViewController:TableViewController;
		private var _toggleButton:ToggleButtonController;
		/**
		 * @private
		 */
		protected var _rootRow:View;

		private var _listHeightInterp:NumericalInterpolator;
		private var _listPosInterp:NumericalInterpolator;

		public var topRowBorderThickness:int = 0;

		private var _placeholder:AbstractLabel;

		private var _listHeight:Number = 200;

		public var transitionSteps:int = Application.frameRate / 7;
		public var openEasing:IEasing = RPSine.easeOut();
		public var closeEasing:IEasing = RPSine.easeIn();

		/**
		 * コンストラクタ.
		 * @param config 設定クラス
		 * @param dataSource データソース
		 *
		 */
		public function DropdownListController(config:IDropdownListSkin, dataSource:ITableViewDataSource, tableViewBorderThickness:int = 0)
		{
			_toggleButton = config.getToggleButton();
			_rootRow = config.getRootRow();

			_tableViewController = new TableViewController(config.getScrollBarView(), tableViewBorderThickness);
			_tableViewController.view.frame.set(0, _rootRow.frame.height / 2, 0, 0);
			_tableViewController.dataSource = dataSource;
			// はみ出し隠す.
			_tableViewController.view.visible = false;

			view.addChild(_tableViewController.view);
			view.addChild(_rootRow);
			view.addChild(_toggleButton.view);


			_rootRow.frame.height = _toggleButton.view.frame.height;

			_placeholder = config.getPlaceholder();
			_rootRow.layoutManager.addManagedTarget(_placeholder, 1, 1);
			_rootRow.setNeedDisplay();

			_rootRow.addChild(_placeholder);
			//_rootRow.layoutManager.addManagedTarget(_placeholder, 1, 1);
		}

		/**
		 * @inheritDoc
		 *
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			_toggleButton.addEventListener(Event.CHANGE, toggleButtonClickListener);
			_rootRow.addEventListener(MouseEvent.CLICK, rootRowClickListener);

			Application.getDocumentClass().stage.addEventListener(MouseEvent.CLICK, stageClickListener);
		}

		/**
		 * @inheritDoc
		 *
		 */
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			_toggleButton.removeEventListener(Event.CHANGE, toggleButtonClickListener);
			_rootRow.removeEventListener(MouseEvent.CLICK, rootRowClickListener);
			Application.getDocumentClass().stage.removeEventListener(MouseEvent.CLICK, stageClickListener);
		}

		public function get tableViewController():TableViewController
		{
			return _tableViewController;
		}

		/**
		 * アイテムが選択されていないときにラベルに表示する文字列です.
		 * @param str
		 *
		 */
		public function get placeholder():String
		{
			return _placeholder.text;
		}

		public function set placeholder(str:String):void
		{
			_placeholder.text = str;
			_placeholder.sizeToFit();

			if (_placeholder.x + _placeholder.width > view.width - _toggleButton.view.width)
				_placeholder.width = view.width - _placeholder.x - _toggleButton.view.width;
			_placeholder.text = str;
			_rootRow.setNeedDisplay();
			_placeholder.setNeedDisplay();
		}

		public function get placeholderLabel():AbstractLabel
		{
			return _placeholder;
		}

		/**
		 * @inheritDoc
		 *
		 */
		override public function viewWillDraw():void
		{
			super.viewWillDraw();

			_rootRow.frame.set(0, 0, view.frame.width - view.frame.height + topRowBorderThickness, view.frame.height);
			_rootRow.setNeedDisplay();

			_toggleButton.view.frame.width = _toggleButton.view.frame.height = view.frame.height;
			_toggleButton.view.frame.x = view.frame.width - _toggleButton.view.frame.width;
			_toggleButton.view.setNeedDisplay();

			_tableViewController.view.frame.width = view.frame.width;
			_tableViewController.view.setNeedDisplay();

			_toggleButton
		}

		private var _isOpen:Boolean = false;

		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		private function toggleButtonClickListener(e:Event):void
		{
			if (_toggleButton.isOn)
				open();
			else
				close();
		}

		public function open():void
		{
			if (!_isOpen)
			{
				var contHeight:Number = _tableViewController.dataSource.getRowHeight(0)/* */ * _tableViewController.dataSource.numberOfRows();
				// 上下ボーダー分
				var scrlv:ScrollView = (_tableViewController.view as ScrollView);
				var offset:Number = 0;
				if (scrlv)
					offset = scrlv.maskPadding * 2;
				if (_listHeight > contHeight - offset)
					_listHeight = contHeight - offset;

				_listHeightInterp = new NumericalInterpolator(_listHeight, 0, transitionSteps, openEasing);
				_listPosInterp = new NumericalInterpolator(_rootRow.frame.height - topRowBorderThickness, 0, transitionSteps, openEasing);
				Application.getDocumentClass().addEventListener(Event.ENTER_FRAME, toggleTransition);
				_tableViewController.view.visible = true;
				_isOpen = true;
				_toggleButton.on();
			}
		}

		public function close():void
		{
			if (_isOpen)
			{
				_listHeightInterp = new NumericalInterpolator(0, _tableViewController.view.frame.height, transitionSteps, closeEasing);
				_listPosInterp = new NumericalInterpolator(_rootRow.height / 2, _tableViewController.view.frame.y, transitionSteps, closeEasing);
				Application.getDocumentClass().addEventListener(Event.ENTER_FRAME, toggleTransition);
				_isOpen = false;
				_toggleButton.off();
			}
		}

		public function set listHeight(val:Number):void
		{
			_listHeight = val;
		}

		private function rootRowClickListener(e:MouseEvent):void
		{
			if (_toggleButton.isOn)
				_toggleButton.off();
			else
				_toggleButton.on();
		}

		private function toggleTransition(e:Event):void
		{
			_tableViewController.view.frame.height = _listHeightInterp.next();
			_tableViewController.view.frame.y = _listPosInterp.next();
			_tableViewController.reload();
			_tableViewController.view.setNeedDisplay();

			if (_listHeightInterp.isEnd)
			{
				Application.getDocumentClass().removeEventListener(Event.ENTER_FRAME, toggleTransition);
				if (_tableViewController.view.frame.height < _rootRow.frame.height)
					_tableViewController.view.visible = false;
			}
		}

		private function stageClickListener(e:MouseEvent):void
		{
			var doc:Sprite = Application.getDocumentClass();
			var hitArea:Frame = view.getGlobalFrame();
			hitArea.width = view.frame.width;
			hitArea.height = view.frame.height + _listHeight;
			if (!hitArea.contains(doc.mouseX, doc.mouseY))
			{
				//e.stopImmediatePropagation();
				close();
			}
		}


	}
}