package as3_user_interface_kit.controllers
{
	import as3_animation_kit.NumericalInterpolator;
	import as3_animation_kit.interpolator.RPCirc;
	
	import as3_user_interface_kit.Application;
	import as3_foundation.Performer;
	import as3_foundation.Wait;
	
	import as3_user_interface_kit.events.DragDropEvent;
	import as3_user_interface_kit.models.IEditableListDataSource;
	import as3_user_interface_kit.views.VerticalScrollBarView;
	import as3_user_interface_kit.views.View;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;

	public class EditableTableViewController extends TableViewController
	{
		private var _reception:DragReceptionController;
		private var _currentItem:IDraggableViewController;
		/* ドラッグするアイテムのゴースト */
		private var _dragCellData:Object;
		/* ドラッグ中のアイテムのデータ */
		private var _dragItemIndex:int;
		/* ドラッグ中のアイテムの先頭行から数えた番号 */
		private var _borderItemIndex:int;
		/* 行の挿入先番号 */
		private var _nowSlidingCount:int;
		/* スライド中の行の数 */
		private var _removedItem:ITableCellController;
		private var _borderLine:Shape;
		private var _decreases:Array;
		private var _nowSliding:Boolean = false;
		private var _didSlided:Boolean = true;
		private var _yInterp:NumericalInterpolator;

		/**
		 * コンストラクタ.
		 */
		public function EditableTableViewController(v:VerticalScrollBarView)
		{
			super(v);
			_reception = new DragReceptionController();
			scrollView.addChildToBaseLayer(_reception.view);

			_borderLine = new Shape();
			_borderLine.graphics.beginFill(0x0000ff);
			_borderLine.graphics.drawRect(0, 0, 1, 5);
			_borderLine.graphics.endFill();

			// sourceLayer = _reception;
		}

		override public function viewDidAppear():void
		{
			super.viewDidAppear();
		}

		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			var l:int = dataSource.numberOfRows();
			for (var i:int = 0; i < l; i++)
			{
				var t:IDraggableViewController = dataSource.cellForRowAt(i) as IDraggableViewController;
				t.removeEventListener(DragDropEvent.START_DRAG, onDrag);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function viewWillDraw():void
		{
			super.viewWillDraw();
			_reception.view.frame.width = view.frame.width;
			_reception.view.frame.height = view.frame.height;
			_borderLine.width = view.frame.width;
			// _reception.view.setNeedDisplay();
		}

		/**
		 * @inheritDoc
		 *
		 */
		override public function addReusableCell(cell:ITableCellController):void
		{
			super.addReusableCell(cell);
			var ddItem:IDraggableViewController = cell as IDraggableViewController;
			//ddItem.addTarget(this, onDrag, DragItem.START_DRAG);
			ddItem.addEventListener(DragDropEvent.START_DRAG, onDrag);
		}

		private function checkRemoveComp(e:Event):void
		{
			if (!_nowSliding && _didSlided)
			{
				view.removeEventListener(Event.ENTER_FRAME, checkRemoveComp);
				new Wait(100, new Performer(this, addRowAt, _borderItemIndex, _dragCellData));
			}
		}

		/**
		 * 1行追加します.
		 */
		public function addRowAt(index:int, data:Object):void
		{
			// 表示中の行で、一番上に位置するもの
			// var nowTopIndexMinusOne:int = nowTopIndex;

			_nowSlidingCount = bottomIndex - index;
			_decreases = [];

			for (var i:int = index; i < index + _nowSlidingCount; i++)
			{
				var cell:ITableCellController = dataSource.cellForRowAt(i) as ITableCellController;
				var dec:NumericalInterpolator = new NumericalInterpolator(cell.view.frame.y + cell.view.frame.height, cell.view.frame.y, Application.frameRate / 5, RPCirc.easeIn());
				_decreases.push({'c': cell, 'dec': dec});
			}

			_nowSliding = true;
			_didSlided = false;

			var source:IEditableListDataSource = dataSource as IEditableListDataSource;
			source.addDataTo(data, index);
			view.addEventListener(Event.ENTER_FRAME, slideCell);
		}

		/**
		 * 行を削除します.
		 */
		public function removeRowAt(index:int):void
		{
			_removedItem = dataSource.cellForRowAt(index) as ITableCellController;
			_removedItem.view.scaleX = _removedItem.view.scaleY = 0;
			_nowSlidingCount = bottomIndex - index + 1;

			if (index + _nowSlidingCount > dataSource.numberOfRows())
				_nowSlidingCount = dataSource.numberOfRows() - index;
			_decreases = [];

			for (var i:int = index; i < index + _nowSlidingCount; i++)
			{
				var c:ITableCellController = dataSource.cellForRowAt(i) as ITableCellController;
				var dec:NumericalInterpolator = new NumericalInterpolator(c.view.frame.y - c.view.frame.height, c.view.frame.y, Application.frameRate / 5, RPCirc.easeIn());
				_decreases.push({'c': c, 'dec': dec});
			}
			_nowSliding = true;
			_didSlided = false;
			var source:IEditableListDataSource = dataSource as IEditableListDataSource;
			source.removeDataAt(index);
			view.addEventListener(Event.ENTER_FRAME, slideCell);
		}

		private function slideCell(e:Event):void
		{
			var cnt:int = 0;
			for (var i:int = 0; i < _decreases.length; i++)
			{
				var obj:Object = _decreases[i];
				var c:ITableCellController = obj.c as ITableCellController;
				var dec:NumericalInterpolator = obj.dec as NumericalInterpolator;
				c.view.frame.y = c.view.frame.y = dec.next();
				if (dec.isEnd)
					cnt++;
				c.view.setNeedDisplay();
			}

			if (cnt == _nowSlidingCount)
			{
				view.removeEventListener(Event.ENTER_FRAME, slideCell);

				view.setNeedDisplay();
				scrollUpdate(null);
				if (_removedItem)
					_removedItem.view.scaleX = _removedItem.view.scaleY = 1;

				_nowSliding = false;
				_didSlided = true;
				_decreases = null;
			}
		}

		// ドラッグ＆ドロップ周りの処理
		// ===========================================================
		private function onDrag(e:DragDropEvent):void
		{
			if (_nowSliding)
				return;
			_currentItem = e.dragging as IDraggableViewController;

			var item:ITableCellController = _currentItem as ITableCellController;
			_dragItemIndex = item.index;
			_dragCellData = item.cellData;

			//_currentItem.addTarget(this, onDrop, DragItem.STOP_DRAG);
			_currentItem.addEventListener(DragDropEvent.STOP_DRAG, onDrop);
			_yInterp = new NumericalInterpolator(item.view.frame.height / 2, item.view.mouseY, Application.frameRate / 5, RPCirc.easeIn());

			view.addChild(_borderLine);
			var pos:Point = _currentItem.view.getCoordinateIn(view);
			view.addChild(_currentItem.ghost);
			_currentItem.ghost.frame.y = pos.y;
			_currentItem.ghost.setNeedDisplay();
			_borderLine.y = _currentItem.ghost.y;

			_currentItem.onDrag();
			view.addEventListener(Event.ENTER_FRAME, moveItem);
		}

		private function onDrop(e:DragDropEvent):void
		{
			view.removeChild(_borderLine);

			if (_borderItemIndex == _dragItemIndex)
			{
				// clean
				view.removeEventListener(Event.ENTER_FRAME, moveItem);
				_currentItem.removeEventListener(DragDropEvent.STOP_DRAG, onDrop);
				view.removeChild(_currentItem.ghost);
				_currentItem.onDrop();
				return;
			}

			removeRowAt(_dragItemIndex);
			view.addEventListener(Event.ENTER_FRAME, checkRemoveComp);

			_currentItem.onDrop();

			// clean
			view.removeEventListener(Event.ENTER_FRAME, moveItem);
			view.removeChild(_currentItem.ghost);
		}

		private function moveItem(e:Event):void
		{
			var ghost:View = _currentItem.ghost;
			var ghostPos:Point = ghost.frame.topLeft;
			ghostPos.x = 5;

			// ghost の中心をマウスにあわせる
			var offsetY:Number = _yInterp.next();
			if (_yInterp.isEnd)
				offsetY = _yInterp.targetValue;
			ghostPos.y = view.mouseY - offsetY;

			// はみ出ないように
			if (ghostPos.y < 0)
				ghostPos.y = 0;
			else if ((ghostPos.y + ghost.frame.height) > view.frame.height)
				ghostPos.y = view.frame.height - ghost.frame.height;

			// ボーダーの位置とインデックスを求める
			var tmpY:int = 0;
			var dist:Number = view.frame.height;
			for (var i:int = topIndex; i < bottomIndex; i++)
			{
				if (i < dataSource.numberOfRows())
				{
					var c:ITableCellController = dataSource.cellForRowAt(i);

					if (dist > Math.abs(c.view.frame.y - ghostPos.y))
					{
						_borderItemIndex = c.index;
						if (_dragItemIndex < _borderItemIndex)
						{
							_borderItemIndex -= 1;
						}

						dist = Math.min(dist, Math.abs(c.view.frame.y - ghost.y));
						tmpY = c.view.frame.y;
					}
				}
			}
			ghost.setNeedDisplay();
			_borderLine.y = tmpY;
		}
	}
}