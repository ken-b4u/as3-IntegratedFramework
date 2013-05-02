package as3_user_interface_kit.views
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import as3_user_interface_kit.Frame;



	/**
	 * スクロール可能領域です。
	 * コンストラクタに渡された設定オブジェクトからスクロールバーを取得し、マスク管理、スクロール管理を行います。
	 * マスクされる領域の定義は、maskFrame の値を操作して行います。
	 * @author takanosatoshi
	 *
	 */
	public class ScrollView extends View implements IMaskable
	{
		/**
		 * マスクの影響を受けないレイヤーです.
		 */
		protected var baseLayer:Sprite;
		/**
		 * マスクのターゲットとなるレイヤーです.
		 */
		protected var _sourceLayer:View;
		private var _maskLayer:Sprite;
		private var _mask:Shape;
		private var _maskFrame:Frame;

		public var maskPadding:int = 0;
		/**
		 * コンストラクタ.
		 *
		 */
		public function ScrollView()
		{
			baseLayer = new Sprite();
			addChild(baseLayer);
			_sourceLayer = new View();
			addChild(_sourceLayer);
			_maskLayer = new Sprite();
			addChild(_maskLayer);

			_mask = new Shape();
			_maskFrame = new Frame(0, 0, 10, 10);
			_sourceLayer.mask = _maskLayer;

			createMask();
		}

		/**
		 * @inheritDoc
		 */
		override protected function draw():void
		{
			super.draw();
			_maskFrame.width = frame.width - maskPadding * 2;
			_maskFrame.height = frame.height - maskPadding * 2;
			_maskLayer.x = _maskFrame.x + maskPadding;
			_maskLayer.y = _maskFrame.y + maskPadding;

			_mask.width = _maskFrame.width;
			_mask.height = _maskFrame.height;
		}

		/**
		 * @inheritDoc
		 */
		public function get maskFrame():Frame
		{
			return _maskFrame;
		}

		public function set maskFrame(mask:Frame):void
		{
			_maskFrame = mask;
			setNeedDisplay();
		}

		/**
		 * 最下層のレイヤーに表示オブジェクトを追加します.
		 * <p>このレイヤーに追加された表示オブジェクトは、マスクの影響を受けません。</p>
		 * @param child
		 * @return
		 *
		 */
		public function addChildToBaseLayer(child:DisplayObject):void
		{
			baseLayer.addChild(child);
		}

		/**
		 * 最下層のレイヤーから表示オブジェクトを削除します.
		 * @param child
		 * @return
		 *
		 */
		public function removeChildFromBaseLayer(child:DisplayObject):void
		{
			baseLayer.removeChild(child);
		}

		/**
		 * @inheritDoc
		 */
		public function addChildToMaskedPane(child:DisplayObject):void
		{
			_sourceLayer.addChild(child);
			_sourceLayer.sizeToFit();
		}

		/**
		 * @inheritDoc
		 */
		public function removeChildFromMaskingPane(child:DisplayObject):void
		{
			_sourceLayer.removeChild(child);
		}

		private function createMask():void
		{
			var graphic:Graphics = _mask.graphics;
			graphics.clear();
			graphic.beginFill(0)
			graphic.drawRect(0, 0, _maskFrame.width, _maskFrame.height);
			graphic.endFill();
			_maskLayer.addChild(_mask);
		}

		public function get sourceLayer():Sprite
		{
			return _sourceLayer;
		}

		public function get maskLayer():Sprite
		{
			return _maskLayer;
		}
	}
}