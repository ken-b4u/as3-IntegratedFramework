package as3_user_interface_kit {
	
	import as3_user_interface_kit.views.View;
	
	import flash.geom.Point;

	/**
	 * 表示オブジェクトのレイアウトを管理します。
	 * @author takanosatoshi
	 *
	 */
	public class Grid9Layout {
		private var fixObj:View;
		private var _objects:Array;
		private var _hasTarget:Boolean = false;

		/**
		 * NineGridLayout オブジェクトを作成します.
		 * @param fixObj レイアウトの基準とするViewオブジェクト.
		 *
		 */
		public function Grid9Layout(fixObj:View) {
			this.fixObj = fixObj;
			_objects = [];
			for (var i:int = 0; i < 9; i++) {
				_objects[i] = [];
			}
		}

		/**
		 * レイアウト管理対象を追加します.
		 * <p>マージンは、左列であれば左端からのマージン、右列であれば右端からのマージン、中央であれば無視されます。<br />
		 * 上下マージンに関しても行の上下について同様です。</p>
		 * @param t 対象オブジェクト
		 * @param row 追加先の行
		 * @param col 追加先の列
		 * @param marginLeftOrRight 左または右のマージン
		 * @param marginTopOrBottom 上または下のマージン
		 */
		public function addManagedTarget(t:View, row:int, col:int, marginLeftOrRight:int = 0, marginTopOrBottom:int = 0):void {
			var index:int = row * 3 + col;
			var l:Number = _objects[index].length;
			for (var i:int = 0; i < l; i++) {
				if ( _objects[index][i].target == t) return;
			}
			var obj:Object = {target:t, marginLeftOrRight:marginLeftOrRight, marginTopOrBottom:marginTopOrBottom};
			_objects[index].push(obj);
			
			_hasTarget = true;
		}
		
		public function removeManagedTarget(t:View, row:int, col:int):void
		{
			var index:int = row * 3 + col;
			var l:Number = _objects[index].length;
			for (var i:int = 0; i < l; i++) {
				if ( _objects[index][i].target == t) {
					_objects[index].splice(i, 1);
					return;
				}
			}
		}

		/**
		 * レイアウトを更新します.
		 *
		 */
		public function update():void {
			if(_hasTarget) {
			var fixW:Number = fixObj.frame.width;
			var fixH:Number = fixObj.frame.height;

			for (var i:int = 0; i < 9; i++) {
				var cell:Array = _objects[i];
				var len:int = cell.length;

				for (var j:int = 0; j < len; j++) {
					var obj:Object = cell[j];
					var target:View = obj.target;
					var targetFrame:Frame = target.frame;
					

					var row:int = i / 3;
					var col:int = i % 3;
					
					// 上段
					if (row == 0) targetFrame.y = obj.marginTopOrBottom;
					// 中段
					else if (row == 1) targetFrame.y = (fixH - targetFrame.height) / 2;
					// 下段
					else targetFrame.y = fixH - targetFrame.height - obj.marginTopOrBottom;

					// 左
					if ( col == 0 ) targetFrame.x = obj.marginLeftOrRight; 
					// 中央
					else if (col == 1) {
						targetFrame.x = (fixW - targetFrame.width) / 2;
					} 
					// 右
					else targetFrame.x = fixW - targetFrame.width - obj.marginLeftOrRight;
					
					target.setNeedDisplay();
				}
			}
			}
		}
	}
}