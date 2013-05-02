//cell 高さ一律
package as3_user_interface_kit.controllers
{
	import as3_user_interface_kit.Frame;
	import as3_foundation.log.Logger;
	
	import as3_user_interface_kit.events.ScrollEvent;
	import as3_user_interface_kit.models.ITableViewDataSource;
	import as3_user_interface_kit.views.VerticalScrollBarView;
	
	/**
	 * リストのコントローラ.
	 * <p>行の表示オブジェクトや行ごとのデータと分離し、並べた行のスクロールをコントロールするのみに焦点をあてています。</p>
	 * <p>また、可視領域内を埋めるのに必要最小限な数の行表示オブジェクトを生成し、パフォーマンス向上のため再利用するインタフェースを備えています。
	 * 下記にその例を示します。</p>
	 *
	 * <listing version="3.0" >
	 *
	 *
	 * public function cellForRowAt(index:int):ITableCellController {
	 * // cellForRowAt メソッドは TableViewController クラスの dataSource プロパティになっているオブジェクトです。
	 * // このメソッドは、必要なときに TableViewController インスタンスから呼び出されます。
	 *
	 * // キューから再利用可能な行オブジェクトを取り出す
	 *	var cell:ITableCellController = list.dequeueReusableCellAt(index);
	 *
	 * // 再利用可能な行がなかったら新しく作成する
	 *	if (!cell) {
	 *			cell = new TableCellController(cellView);
	 *			cell.view.frame.set(0, 0, list.view.width, getRowHeight());
	 *			// 再利用可能な行として登録
	 *			list.addReusableCell(cell);
	 *		}
	 * 		// 行ごとに固有のデータを入れる.
	 *		cell.cellData = data[index];
	 *		return cell;
	 *	}
	 * </listing>
	 * <p>以上が<code>TableViewController</code>を使うときのメインのコードです。</p>
	 * <p>このクラスは、行が選択された際のイベント発行は行わないため、データソースの<code>cellForRowAt</code>内で、行自身にイベントリスナを張ってください。</p>
	 * <p>このクラスを使用する時は、<code>ITableViewDataSource</code>を実装したクラスが１つ必要になります。
	 * このインタフェースは、<code>TableViewController</code>への行情報を提供するためのインタフェースです。
	 * 上記に示した<code>cellForRowAt(index:int)</code>以外に、行の数、行の高さを返すメソッドを実装する必要があります。</p>
	 *
	 * @author takanosatoshi
	 * @see as3_user_interface_kit.models.ITableViewDataSource
	 */
	public class TableViewController extends ScrollViewController
	{
		private var _dataSource:ITableViewDataSource;
		private var _cellQueue:Array;
		private var _selectedIndex:int = -1;
		
		
		/**
		 * 行のボーダーの太さ.
		 * <p>行の外見にボーダーがある場合、並んだ行の間のボーダーの太さが２倍に見えてしまいます。</br>
		 * このプロパティはその問題を解消するためのものです。</p>
		 */
		public var cellViewBorderThickness:int = 0;
		public var fitCellWidth:Boolean = true;
		public var cellWidthIsTableWidthAnyway:Boolean = false;
		
		/**
		 * コンストラクタ.
		 * @param
		 */
		public function TableViewController(scrollBarView:VerticalScrollBarView, tableViewBorderThickness:int = 0):void
		{
			super(scrollBarView);
			
			scrollBar.setMouseWheelListener(this.view);
			/*scrollView.sourceLayer.mask = null;
			scrollView.maskLayer.visible = false;*/
			_cellQueue = new Array();
			scrollView.maskPadding = tableViewBorderThickness;
		}
		
		/**
		 * @inheirtDoc s
		 */
		override public function viewDidAppear():void
		{
			super.viewDidAppear();
			scrollBar.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
			scrollUpdate(null);
		}
		
		public function scrollTo(index:int, animated:Boolean = false):void
		{
			var step:int = scrollBar.scrollBarView.transitionSteps;
			if (!animated)
				scrollBar.scrollBarView.transitionSteps = 1;
			// bad
			//scrollBar.scrollRatio = _dataSource.getRowHeight() * index / calcScrollViewHeight();
			// good
			//scrollBar.scrollRatio = index * _dataSource.getRowHeight() / (scrollBar.contentSize - view.height)
			scrollBar.scrollRatio = getRowsHeight(index) / (scrollBar.contentSize - view.height)
			scrollBar.scrollBarView.transitionSteps = step;
		}
		
		/**
		 * @inheirtDoc s
		 */
		override public function viewDidDisappear():void
		{
			super.viewDidDisappear();
			
			scrollBar.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
		}
		
		/**
		 * 行データを再取得して表示を更新します.
		 */
		public function reload():void
		{
			view.setNeedDisplay();
			scrollUpdate(null);
		}
		
		/**
		 * 再利用可能な行オブジェクトを返します.
		 * @param index
		 * @return
		 *
		 */
		public function dequeueReusableCellAt(index:int):ITableCellController
		{
			if (!view.wasActivated)
				return null;
			//var visibleCount:int = view.height / _dataSource.getRowHeight() + 3;
			var visibleCount:int = view.height / getMinimumRowHeight() + 3;
			var cell:ITableCellController = _cellQueue[index % visibleCount];
			return cell;
		}
		
		/**
		 * 再利用するための行オブジェクト追加します.
		 * @param cell
		 *
		 */
		public function addReusableCell(cell:ITableCellController):void
		{
			_cellQueue.push(cell);
			cell.view.width = (view.width - (fitCellWidth ? 0 : scrollBar.view.width)) + cellViewBorderThickness * 2;
			cell.view.x = -cellViewBorderThickness;
		}
		
		/**
		 * 行データの提供元オブジェクトです.
		 * @return
		 *
		 */
		public function get dataSource():ITableViewDataSource
		{
			return _dataSource;
		}
		
		public function set dataSource(source:ITableViewDataSource):void
		{
			_dataSource = source;
			view.setNeedDisplay();
		}
		
		/**
		 * 再利用のため保持されている<code>ITableCellController</code>インスタンスを破棄します.
		 *
		 */
		public function destroyReusableCells():void
		{
			while (_cellQueue.length)
			{
				if (_cellQueue[0].view.parent == null)
					_cellQueue.shift();
				else
					scrollView.removeChildFromMaskingPane(_cellQueue[0].view);
				_cellQueue.shift();
			}
		}
		
		/**
		 * @inheirtDoc
		 */
		override public function viewWillDraw():void
		{
			// var oldRatio:Number = scrollBar.scrollRatio;
			if (!_dataSource || !view.wasActivated)
			{
				Logger.instance().warn("TableViewController インスタンスの dataSource プロパティが設定されていません");
				return;
			}
			
			super.viewWillDraw();
			
			var w:Number = view.width;
			var h:Number = view.height;
			
			var contH:Number = calcScrollViewHeight();
			if (scrollBar.contentSize != contH)
				scrollBar.contentSize = contH;
			
			var padding:Number = scrollBar.view.width;
			scrollBar.view.height = h;
			scrollBar.isEnabled = scrollBar.needVisibility;
			
			if (scrollBar.isEnabled)
			{
				padding = scrollBar.view.width;
			}
			else
			{
				if (scrollBar.scrollRatio > 0)
					scrollTo(0);
				if (fitCellWidth)
					padding = 0;
			}
			
			view.height = h;
			scrollBar.view.x = w - padding;
			scrollBar.view.setNeedDisplay();
			
			if (_cellQueue.length)
			{
				if (cellWidthIsTableWidthAnyway)
					padding = 0;
				for (var j:int = 0; j < _cellQueue.length; j++)
				{
					var c:ITableCellController = _cellQueue[j];
					c.view.width = (w - padding) + cellViewBorderThickness * 2;
					c.view.setNeedDisplay();
				}
			}
			
			scrollBar.scrollRatio = scrollBar.scrollRatio;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function scrollUpdate(e:ScrollEvent):void
		{
			if (!view.wasActivated || !_dataSource)
				return;
			
			// 表示中の行で、一番上に位置するもの
			var nowTopIndexMinusOne:int = topIndex - 1;
			var visibleCount:int = 0;
			var h:int = view.height;
			var t:int = 0 <= nowTopIndexMinusOne ? nowTopIndexMinusOne : 0;
			while (0 < h) {
				h -= _dataSource.getRowHeight(t + visibleCount++);
			}
			visibleCount--;
			var maskHeight:Number = view.height;
			var contSize:Number = calcScrollViewHeight();
			
			var scrollRatio:Number = scrollBar.scrollRatio;
			
			for (var i:int = nowTopIndexMinusOne; i < nowTopIndexMinusOne + visibleCount + 3 /*下が足りなくならないように、多めにCellを作る*/; i++)
			{
				if (0 <= i && i < _dataSource.numberOfRows())
				{
					var cell:ITableCellController = _dataSource.cellForRowAt(i);
					var cellFrame:Frame = cell.view.frame; // 処理回数多めなので、アクセサのオーバーヘッド軽くするため
					var frame:Frame = view.frame; // 同上
					cell.index = i;
					scrollView.addChildToMaskedPane(cell.view);
					
					cellFrame.y = -(contSize - maskHeight) * scrollRatio + getRowsHeight(i);
					cell.view.setNeedDisplay();
				}
			}
		}
		
		/**
		 * 不可視状態になっている行の数.　一部でも表示上省略されているものはカウントに含める.
		 */
		protected function get invisibleCount():int
		{
			var h:Number = (scrollBar.contentSize - view.height) * scrollBar.scrollRatio;
			var cnt:int = 0;
			while (0 < h) {
				h -= _dataSource.getRowHeight(cnt++);
			}
			return cnt;
		}
		
		/**
		 * 可視領域の最上段にある行のインデックス. 見切れているものも対象に含める.
		 */
		protected function get topIndex():int
		{
			return Math.max(invisibleCount, 0);
		}
		
		/**
		 * 可視領域の最下段にある行のインデックス.
		 */
		protected function get bottomIndex():int
		{
			var top:int = topIndex;
			var h:Number = view.height;
			while (0 < h) {
				h -= _dataSource.getRowHeight(top++)
			}
			return top + 1;
		}
		
		/**
		 * 全ての行の高さの和を計算して返します.
		 */
		protected function calcScrollViewHeight():Number
		{
			/*var off:Number = cellViewBorderThickness * (dataSource.numberOfRows() - 1);
			//trace(off)
			var res:Number = _dataSource.getRowHeight() * _dataSource.numberOfRows() - off;*/
			return getRowsHeight(_dataSource.numberOfRows());
		}
		
		private function getRowsHeight(whileIndex:int):Number {
			var h:Number = 0;
			for (var i:int = 0; i < whileIndex; i++) h += _dataSource.getRowHeight(i);
			return h;
		}
		
		private function getMinimumRowHeight():Number {
			var h:Number = _dataSource.getRowHeight(0);
			for (var i:int = 1, l:int = _dataSource.numberOfRows(); i < l; i++) h = Math.min(h, _dataSource.getRowHeight(i));
			return h;
		}
		
	}
}

// cell 高さ一律
//package as3_user_interface_kit.controllers
//{
//	import as3_user_interface_kit.events.ScrollEvent;
//	import as3_user_interface_kit.models.ITableViewDataSource;
//	import as3_user_interface_kit.views.VerticalScrollBarView;
//	import foundation.Frame;
//	import foundation.log.Logger;
//
//	/**
//	 * リストのコントローラ.
//	 * <p>行の表示オブジェクトや行ごとのデータと分離し、並べた行のスクロールをコントロールするのみに焦点をあてています。</p>
//	 * <p>また、可視領域内を埋めるのに必要最小限な数の行表示オブジェクトを生成し、パフォーマンス向上のため再利用するインタフェースを備えています。
//	 * 下記にその例を示します。</p>
//	 *
//	 * <listing version="3.0" >
//	 *
//	 *
//	 * public function cellForRowAt(index:int):ITableCellController {
//	 * // cellForRowAt メソッドは TableViewController クラスの dataSource プロパティになっているオブジェクトです。
//	 * // このメソッドは、必要なときに TableViewController インスタンスから呼び出されます。
//	 *
//	 * // キューから再利用可能な行オブジェクトを取り出す
//	 *	var cell:ITableCellController = list.dequeueReusableCellAt(index);
//	 *
//	 * // 再利用可能な行がなかったら新しく作成する
//	 *	if (!cell) {
//	 *			cell = new TableCellController(cellView);
//	 *			cell.view.frame.set(0, 0, list.view.width, getRowHeight());
//	 *			// 再利用可能な行として登録
//	 *			list.addReusableCell(cell);
//	 *		}
//	 * 		// 行ごとに固有のデータを入れる.
//	 *		cell.cellData = data[index];
//	 *		return cell;
//	 *	}
//	 * </listing>
//	 * <p>以上が<code>TableViewController</code>を使うときのメインのコードです。</p>
//	 * <p>このクラスは、行が選択された際のイベント発行は行わないため、データソースの<code>cellForRowAt</code>内で、行自身にイベントリスナを張ってください。</p>
//	 * <p>このクラスを使用する時は、<code>ITableViewDataSource</code>を実装したクラスが１つ必要になります。
//	 * このインタフェースは、<code>TableViewController</code>への行情報を提供するためのインタフェースです。
//	 * 上記に示した<code>cellForRowAt(index:int)</code>以外に、行の数、行の高さを返すメソッドを実装する必要があります。</p>
//	 *
//	 * @author takanosatoshi
//	 * @see as3_user_interface_kit.models.ITableViewDataSource
//	 */
//	public class TableViewController extends ScrollViewController
//	{
//		private var _dataSource:ITableViewDataSource;
//		private var _cellQueue:Array;
//		private var _selectedIndex:int = -1;
//
//
//		/**
//		 * 行のボーダーの太さ.
//		 * <p>行の外見にボーダーがある場合、並んだ行の間のボーダーの太さが２倍に見えてしまいます。</br>
//		 * このプロパティはその問題を解消するためのものです。</p>
//		 */
//		public var cellViewBorderThickness:int = 0;
//		public var fitCellWidth:Boolean = true;
//		public var cellWidthIsTableWidthAnyway:Boolean = false;
//
//		/**
//		 * コンストラクタ.
//		 * @param
//		 */
//		public function TableViewController(scrollBarView:VerticalScrollBarView, tableViewBorderThickness:int = 0):void
//		{
//			super(scrollBarView);
//
//			scrollBar.setMouseWheelListener(this.view);
//			/*scrollView.sourceLayer.mask = null;
//			scrollView.maskLayer.visible = false;*/
//			_cellQueue = new Array();
//			scrollView.maskPadding = tableViewBorderThickness;
//		}
//
//		/**
//		 * @inheirtDoc s
//		 */
//		override public function viewDidAppear():void
//		{
//			super.viewDidAppear();
//			scrollBar.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
//			scrollUpdate(null);
//		}
//
//		public function scrollTo(index:int, animated:Boolean = false):void
//		{
//			var step:int = scrollBar.scrollBarView.transitionSteps;
//			if (!animated)
//				scrollBar.scrollBarView.transitionSteps = 1;
//			// bad
//			//scrollBar.scrollRatio = _dataSource.getRowHeight() * index / calcScrollViewHeight();
//			// good
//			//scrollBar.scrollRatio = index * _dataSource.getRowHeight() / (scrollBar.contentSize - view.height)
//			scrollBar.scrollRatio = getRowsHeight(index) / (scrollBar.contentSize - view.height)
//			scrollBar.scrollBarView.transitionSteps = step;
//		}
//
//		/**
//		 * @inheirtDoc s
//		 */
//		override public function viewDidDisappear():void
//		{
//			super.viewDidDisappear();
//
//			scrollBar.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
//		}
//
//		/**
//		 * 行データを再取得して表示を更新します.
//		 */
//		public function reload():void
//		{
//			view.setNeedDisplay();
//			scrollUpdate(null);
//		}
//
//		/**
//		 * 再利用可能な行オブジェクトを返します.
//		 * @param index
//		 * @return
//		 *
//		 */
//		public function dequeueReusableCellAt(index:int):ITableCellController
//		{
//			if (!view.wasActivated)
//				return null;
//			//var visibleCount:int = view.height / _dataSource.getRowHeight() + 3;
//			var visibleCount:int = view.height / getMinimumRowHeight() + 3;
//			var cell:ITableCellController = _cellQueue[index % visibleCount];
//			return cell;
//		}
//
//		/**
//		 * 再利用するための行オブジェクト追加します.
//		 * @param cell
//		 *
//		 */
//		public function addReusableCell(cell:ITableCellController):void
//		{
//			_cellQueue.push(cell);
//			cell.view.width = (view.width - (fitCellWidth ? 0 : scrollBar.view.width)) + cellViewBorderThickness * 2;
//			cell.view.x = -cellViewBorderThickness;
//		}
//
//		/**
//		 * 行データの提供元オブジェクトです.
//		 * @return
//		 *
//		 */
//		public function get dataSource():ITableViewDataSource
//		{
//			return _dataSource;
//		}
//
//		public function set dataSource(source:ITableViewDataSource):void
//		{
//			_dataSource = source;
//			view.setNeedDisplay();
//		}
//
//		/**
//		 * 再利用のため保持されている<code>ITableCellController</code>インスタンスを破棄します.
//		 *
//		 */
//		public function destroyReusableCells():void
//		{
//			while (_cellQueue.length)
//			{
//				if (_cellQueue[0].view.parent == null)
//					_cellQueue.shift();
//				else
//					scrollView.removeChildFromMaskingPane(_cellQueue[0].view);
//				_cellQueue.shift();
//			}
//		}
//
//		/**
//		 * @inheirtDoc
//		 */
//		override public function viewWillDraw():void
//		{
//			// var oldRatio:Number = scrollBar.scrollRatio;
//			if (!_dataSource || !view.wasActivated)
//			{
//				Logger.instance().warn("TableViewController インスタンスの dataSource プロパティが設定されていません");
//				return;
//			}
//
//			super.viewWillDraw();
//
//			var w:Number = view.width;
//			var h:Number = view.height;
//
//			var contH:Number = calcScrollViewHeight();
//			if (scrollBar.contentSize != contH)
//				scrollBar.contentSize = contH;
//
//			var padding:Number = scrollBar.view.width;
//			scrollBar.view.height = h;
//			scrollBar.isEnabled = scrollBar.needVisibility;
//			
//			if (scrollBar.isEnabled)
//			{
//				padding = scrollBar.view.width;
//			}
//			else
//			{
//				if (scrollBar.scrollRatio > 0)
//					scrollTo(0);
//				if (fitCellWidth)
//					padding = 0;
//			}
//
//			view.height = h;
//			scrollBar.view.x = w - padding;
//			scrollBar.view.setNeedDisplay();
//
//			if (_cellQueue.length)
//			{
//				if (cellWidthIsTableWidthAnyway)
//					padding = 0;
//				for (var j:int = 0; j < _cellQueue.length; j++)
//				{
//					var c:ITableCellController = _cellQueue[j];
//					c.view.width = (w - padding) + cellViewBorderThickness * 2;
//					c.view.setNeedDisplay();
//				}
//			}
//			
//			scrollBar.scrollRatio = scrollBar.scrollRatio;
//		}
//
//		/**
//		 * @inheritDoc
//		 */
//		override protected function scrollUpdate(e:ScrollEvent):void
//		{
//			if (!view.wasActivated || !_dataSource)
//				return;
//
//			// 表示中の行で、一番上に位置するもの
//			var nowTopIndexMinusOne:int = topIndex - 1;
//			var visibleCount:int = 0;
//			var h:int = view.height;
//			var t:int = 0 <= nowTopIndexMinusOne ? nowTopIndexMinusOne : 0;
//			while (0 < h) {
//				h -= _dataSource.getRowHeight(t + visibleCount++);
//			}
//			visibleCount--;
//			var maskHeight:Number = view.height;
//			var contSize:Number = calcScrollViewHeight();
//
//			var scrollRatio:Number = scrollBar.scrollRatio;
//			
//			for (var i:int = nowTopIndexMinusOne; i < nowTopIndexMinusOne + visibleCount + 3 /*下が足りなくならないように、多めにCellを作る*/; i++)
//			{
//				if (0 <= i && i < _dataSource.numberOfRows())
//				{
//					var cell:ITableCellController = _dataSource.cellForRowAt(i);
//					var cellFrame:Frame = cell.view.frame; // 処理回数多めなので、アクセサのオーバーヘッド軽くするため
//					var frame:Frame = view.frame; // 同上
//					cell.index = i;
//					scrollView.addChildToMaskedPane(cell.view);
//					
//					cellFrame.y = -(contSize - maskHeight) * scrollRatio + getRowsHeight(i);
//					cell.view.setNeedDisplay();
//				}
//			}
//		}
//
//		/**
//		 * 不可視状態になっている行の数.　一部でも表示上省略されているものはカウントに含める.
//		 */
//		protected function get invisibleCount():int
//		{
//			var h:Number = (scrollBar.contentSize - view.height) * scrollBar.scrollRatio;
//			var cnt:int = 0;
//			while (0 < h) {
//				h -= _dataSource.getRowHeight(cnt++);
//			}
//			return cnt;
//		}
//
//		/**
//		 * 可視領域の最上段にある行のインデックス. 見切れているものも対象に含める.
//		 */
//		protected function get topIndex():int
//		{
//			return Math.max(invisibleCount, 0);
//		}
//
//		/**
//		 * 可視領域の最下段にある行のインデックス.
//		 */
//		protected function get bottomIndex():int
//		{
//			var top:int = topIndex;
//			var h:Number = view.height;
//			while (0 < h) {
//				h -= _dataSource.getRowHeight(top++)
//			}
//			return top + 1;
//		}
//
//		/**
//		 * 全ての行の高さの和を計算して返します.
//		 */
//		protected function calcScrollViewHeight():Number
//		{
//			/*var off:Number = cellViewBorderThickness * (dataSource.numberOfRows() - 1);
//			//trace(off)
//			var res:Number = _dataSource.getRowHeight() * _dataSource.numberOfRows() - off;*/
//			return getRowsHeight(_dataSource.numberOfRows());
//		}
//		
//		private function getRowsHeight(whileIndex:int):Number {
//			var h:Number = 0;
//			for (var i:int = 0; i < whileIndex; i++) h += _dataSource.getRowHeight(i);
//			return h;
//		}
//		
//		private function getMinimumRowHeight():Number {
//			var h:Number = _dataSource.getRowHeight(0);
//			for (var i:int = 1, l:int = _dataSource.numberOfRows(); i < l; i++) h = Math.min(h, _dataSource.getRowHeight(i));
//			return h;
//		}
//
//	}
//}







// cell 高さそれぞれ異なる
//package as3_user_interface_kit.controllers
//{
//	import as3_user_interface_kit.events.ScrollEvent;
//	import as3_user_interface_kit.models.ITableViewDataSource;
//	import as3_user_interface_kit.views.VerticalScrollBarView;
//	import foundation.Frame;
//	import foundation.log.Logger;
//	
//	/**
//	 * リストのコントローラ.
//	 * <p>行の表示オブジェクトや行ごとのデータと分離し、並べた行のスクロールをコントロールするのみに焦点をあてています。</p>
//	 * <p>また、可視領域内を埋めるのに必要最小限な数の行表示オブジェクトを生成し、パフォーマンス向上のため再利用するインタフェースを備えています。
//	 * 下記にその例を示します。</p>
//	 *
//	 * <listing version="3.0" >
//	 *
//	 *
//	 * public function cellForRowAt(index:int):ITableCellController {
//	 * // cellForRowAt メソッドは TableViewController クラスの dataSource プロパティになっているオブジェクトです。
//	 * // このメソッドは、必要なときに TableViewController インスタンスから呼び出されます。
//	 *
//	 * // キューから再利用可能な行オブジェクトを取り出す
//	 *	var cell:ITableCellController = list.dequeueReusableCellAt(index);
//	 *
//	 * // 再利用可能な行がなかったら新しく作成する
//	 *	if (!cell) {
//	 *			cell = new TableCellController(cellView);
//	 *			cell.view.frame.set(0, 0, list.view.width, getRowHeight());
//	 *			// 再利用可能な行として登録
//	 *			list.addReusableCell(cell);
//	 *		}
//	 * 		// 行ごとに固有のデータを入れる.
//	 *		cell.cellData = data[index];
//	 *		return cell;
//	 *	}
//	 * </listing>
//	 * <p>以上が<code>TableViewController</code>を使うときのメインのコードです。</p>
//	 * <p>このクラスは、行が選択された際のイベント発行は行わないため、データソースの<code>cellForRowAt</code>内で、行自身にイベントリスナを張ってください。</p>
//	 * <p>このクラスを使用する時は、<code>ITableViewDataSource</code>を実装したクラスが１つ必要になります。
//	 * このインタフェースは、<code>TableViewController</code>への行情報を提供するためのインタフェースです。
//	 * 上記に示した<code>cellForRowAt(index:int)</code>以外に、行の数、行の高さを返すメソッドを実装する必要があります。</p>
//	 *
//	 * @author takanosatoshi
//	 * @see as3_user_interface_kit.models.ITableViewDataSource
//	 */
//	public class TableViewController extends ScrollViewController
//	{
//		private var _dataSource:ITableViewDataSource;
//		private var _cellQueue:Array;
//		private var _selectedIndex:int = -1;
//		
//		
//		/**
//		 * 行のボーダーの太さ.
//		 * <p>行の外見にボーダーがある場合、並んだ行の間のボーダーの太さが２倍に見えてしまいます。</br>
//		 * このプロパティはその問題を解消するためのものです。</p>
//		 */
//		public var cellViewBorderThickness:int = 0;
//		public var fitCellWidth:Boolean = true;
//		public var cellWidthIsTableWidthAnyway:Boolean = false;
//		
//		/**
//		 * コンストラクタ.
//		 * @param
//		 */
//		public function TableViewController(scrollBarView:VerticalScrollBarView, tableViewBorderThickness:int = 0):void
//		{
//			super(scrollBarView);
//			
//			scrollBar.setMouseWheelListener(this.view);
//			/*scrollView.sourceLayer.mask = null;
//			scrollView.maskLayer.visible = false;*/
//			_cellQueue = new Array();
//			scrollView.maskPadding = tableViewBorderThickness;
//		}
//		
//		/**
//		 * @inheirtDoc s
//		 */
//		override public function viewDidAppear():void
//		{
//			super.viewDidAppear();
//			scrollBar.addEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
//			scrollUpdate(null);
//		}
//		
//		public function scrollTo(index:int, animated:Boolean = false):void
//		{
//			var step:int = scrollBar.scrollBarView.transitionSteps;
//			if (!animated)
//				scrollBar.scrollBarView.transitionSteps = 1;
//			// bad
//			//scrollBar.scrollRatio = _dataSource.getRowHeight() * index / calcScrollViewHeight();
//			// good
//			//scrollBar.scrollRatio = index * _dataSource.getRowHeight() / (scrollBar.contentSize - view.height)
//			scrollBar.scrollRatio = getRowsY(index) / (scrollBar.contentSize - view.height)
//			scrollBar.scrollBarView.transitionSteps = step;
//		}
//		
//		/**
//		 * @inheirtDoc s
//		 */
//		override public function viewDidDisappear():void
//		{
//			super.viewDidDisappear();
//			
//			scrollBar.removeEventListener(ScrollEvent.SCROLL_UPDATE, scrollUpdate);
//		}
//		
//		/**
//		 * 行データを再取得して表示を更新します.
//		 */
//		public function reload():void
//		{
//			view.setNeedDisplay();
//			scrollUpdate(null);
//		}
//		
//		/**
//		 * 再利用可能な行オブジェクトを返します.
//		 * @param index
//		 * @return
//		 *
//		 */
//		public function dequeueReusableCellAt(index:int):ITableCellController
//		{
//			if (!view.wasActivated)
//				return null;
//			//var visibleCount:int = view.height / _dataSource.getRowHeight() + 3;
//			var visibleCount:int = view.height / getMinimumRowHeight() + 2;
//			var cell:ITableCellController = _cellQueue[index % visibleCount];
//			return cell;
//		}
//		
//		/**
//		 * 再利用するための行オブジェクト追加します.
//		 * @param cell
//		 *
//		 */
//		public function addReusableCell(cell:ITableCellController):void
//		{
//			_cellQueue.push(cell);
//			cell.view.width = (view.width - (fitCellWidth ? 0 : scrollBar.view.width)) + cellViewBorderThickness * 2;
//			cell.view.x = -cellViewBorderThickness;
//		}
//		
//		/**
//		 * 行データの提供元オブジェクトです.
//		 * @return
//		 *
//		 */
//		public function get dataSource():ITableViewDataSource
//		{
//			return _dataSource;
//		}
//		
//		public function set dataSource(source:ITableViewDataSource):void
//		{
//			_dataSource = source;
//			view.setNeedDisplay();
//		}
//		
//		/**
//		 * 再利用のため保持されている<code>ITableCellController</code>インスタンスを破棄します.
//		 *
//		 */
//		public function destroyReusableCells():void
//		{
//			while (_cellQueue.length)
//			{
//				if (_cellQueue[0].view.parent == null)
//					_cellQueue.shift();
//				else
//					scrollView.removeChildFromMaskingPane(_cellQueue[0].view);
//				_cellQueue.shift();
//			}
//		}
//		
//		/**
//		 * @inheirtDoc
//		 */
//		override public function viewWillDraw():void
//		{
//			// var oldRatio:Number = scrollBar.scrollRatio;
//			if (!_dataSource || !view.wasActivated)
//			{
//				Logger.instance().warn("TableViewController インスタンスの dataSource プロパティが設定されていません");
//				return;
//			}
//			
//			super.viewWillDraw();
//			
//			var w:Number = view.width;
//			var h:Number = view.height;
//			
//			var contH:Number = calcScrollViewHeight();
//			if (scrollBar.contentSize != contH)
//				scrollBar.contentSize = contH;
//			
//			var padding:Number = scrollBar.view.width;
//			scrollBar.view.height = h;
//			scrollBar.isEnabled = scrollBar.needVisibility;
//			
//			if (scrollBar.isEnabled)
//			{
//				padding = scrollBar.view.width;
//			}
//			else
//			{
//				if (scrollBar.scrollRatio > 0)
//					scrollTo(0);
//				if (fitCellWidth)
//					padding = 0;
//			}
//			
//			view.height = h;
//			scrollBar.view.x = w - padding;
//			scrollBar.view.setNeedDisplay();
//			
//			if (_cellQueue.length)
//			{
//				if (cellWidthIsTableWidthAnyway)
//					padding = 0;
//				for (var j:int = 0; j < _cellQueue.length; j++)
//				{
//					var c:ITableCellController = _cellQueue[j];
//					c.view.width = (w - padding) + cellViewBorderThickness * 2;
//					c.view.setNeedDisplay();
//				}
//			}
//			
//			scrollBar.scrollRatio = scrollBar.scrollRatio;
//		}
//		
//		/**
//		 * @inheritDoc
//		 */
//		override protected function scrollUpdate(e:ScrollEvent):void
//		{
//			if (!view.wasActivated || !_dataSource)
//				return;
//			
//			// 表示中の行で、一番上に位置するもの
//			var top:int = topIndex;
//			var visibleCount:int = 0;
//			var h:int = view.height;
//			trace(top);
//			while (0 < h) {
//				if (top + visibleCount < _dataSource.numberOfRows())
//					h -= _dataSource.getRowHeight(top + visibleCount++);
//				else break;
//			}
//			//visibleCount += 1;
//			var maskHeight:Number = view.height;
//			var contSize:Number = calcScrollViewHeight();
//			var scrollRatio:Number = scrollBar.scrollRatio;
//			
//			for (var i:int = topIndex, l:int = top + visibleCount; i < l /*下が足りなくならないように、多めにCellを作る*/; i++)
//			{
//				if (0 <= i && i < _dataSource.numberOfRows())
//				{
//					var cell:ITableCellController = _dataSource.cellForRowAt(i);
//					var cellFrame:Frame = cell.view.frame; // 処理回数多めなので、アクセサのオーバーヘッド軽くするため
//					var frame:Frame = view.frame; // 同上
//					cell.index = i;
//					scrollView.addChildToMaskedPane(cell.view);
//					cellFrame.y = -(contSize - maskHeight) * scrollRatio + getRowsY(i);
//					cell.view.setNeedDisplay();
//				}
//			}
//		}
//		
//		/**
//		 * 可視領域の最上段にある行のインデックス. 見切れているものも対象に含める.
//		 */
//		protected function get topIndex():int
//		{
//			var h:Number = (scrollBar.contentSize - view.height) * scrollBar.scrollRatio;
//			var cnt:int = 0;
//			var ch:Number = _dataSource.getRowHeight(cnt++);
//			while (0 <= h) {
//				h -= ch;
//			}
//			return cnt;
//		}
//		
//		/**
//		 * 可視領域の最下段にある行のインデックス.
//		 */
//		protected function get bottomIndex():int
//		{
//			var top:int = topIndex;
//			var h:Number = view.height;
//			while (0 < h) {
//				h -= _dataSource.getRowHeight(top++)
//			}
//			return top + 1;
//		}
//		
//		/**
//		 * 全ての行の高さの和を計算して返します.
//		 */
//		protected function calcScrollViewHeight():Number
//		{
//			/*var off:Number = cellViewBorderThickness * (dataSource.numberOfRows() - 1);
//			//trace(off)
//			var res:Number = _dataSource.getRowHeight() * _dataSource.numberOfRows() - off;*/
//			return getRowsHeight(_dataSource.numberOfRows() - 1);
//		}
//		
//		private function getRowsHeight(whileIndex:int):Number {
//			var h:Number = 0;
//			for (var i:int = 0; i < whileIndex; i++) h += _dataSource.getRowHeight(i);
//			h += _dataSource.getRowHeight(whileIndex);
//			return h;
//		}
//		
//		private function getRowsY(whileIndex:int):Number {
//			var h:Number = 0;
//			for (var i:int = 0; i < whileIndex; i++) h += _dataSource.getRowHeight(i);
//			return h;
//		}
//		
//		private function getMinimumRowHeight():Number {
//			var h:Number = _dataSource.getRowHeight(0);
//			for (var i:int = 1, l:int = _dataSource.numberOfRows(); i < l; i++) h = Math.min(h, _dataSource.getRowHeight(i));
//			return h;
//		}
//		
//	}
//}