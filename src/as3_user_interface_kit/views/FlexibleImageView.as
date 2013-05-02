package as3_user_interface_kit.views
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * FlexibleImageは、表示オブジェクトの角のRを保持したままサイズ可変とするための表示オブジェクトラッパーです.
	 * <p>表示オブジェクトのRと、枠程度は保持できますが、グラデーションが掛かっていたり、複雑な画像はむりです。</p>
	 */
	public class FlexibleImageView extends View
	{
		private var _bmd:BitmapData;
		private var _mat00:Matrix;
		private var _mat01:Matrix;
		private var _mat10:Matrix;
		private var _mat12:Matrix;
		private var _mat21:Matrix;

		private var _cornerWidth:Number;
		private var _cornerHeight:Number;

		// repeat する必要があるやつ
		private var _tcBmd:BitmapData;
		private var _clBmd:BitmapData;
		private var _ccBmd:BitmapData;
		private var _crBmd:BitmapData;
		private var _bcBmd:BitmapData;

		/**
		 * コンストラクタ.
		 * @param obj 表示オブジェクト
		 * @param cornerWidth Rの幅
		 * @param cornerHeight Rの高さ
		 */
		public function FlexibleImageView(obj:DisplayObject, cornerWidth:Number = 0, cornerHeight:Number = 0)
		{
			_cornerWidth = cornerWidth;
			_cornerHeight = cornerHeight;

			_bmd = new BitmapData(obj.width, obj.height, true, 0);
			_bmd.draw(obj);

			_mat01 = new Matrix(1, 0, 0, 1, -cornerWidth, 0);
			_mat10 = new Matrix(1, 0, 0, 1, 0, -cornerHeight);
			_mat12 = new Matrix(1, 0, 0, 1, -obj.width + _cornerWidth, -cornerHeight);
			_mat21 = new Matrix(1, 0, 0, 1, -cornerWidth, -obj.height + _cornerHeight);

			_tcBmd = new BitmapData(1, _cornerHeight, true, 0);
			_tcBmd.draw(_bmd, _mat01);

			_clBmd = new BitmapData(_cornerWidth, obj.height-cornerHeight*2, true, 0);
			_clBmd.draw(_bmd, _mat10);

			_crBmd = new BitmapData(_cornerWidth, obj.height-cornerHeight*2, true, 0);
			_crBmd.draw(_bmd, _mat12);

			_bcBmd = new BitmapData(1, _cornerHeight, true, 0);
			_bcBmd.draw(_bmd, _mat21);

			_ccBmd = new BitmapData(obj.width - _cornerWidth * 2, obj.height - _cornerHeight * 2, true, 0);
			var mat:Matrix = new Matrix();
			mat.translate(-_cornerWidth, -_cornerHeight);
			_ccBmd.draw(_bmd, mat);
		}


		/**
		 * @inheritDoc
		 * @param w
		 * @param h
		 *
		 */
		override protected function draw():void
		{
			super.draw();

			graphics.clear();

			// TL ==================================================
			var mat:Matrix = new Matrix();
			graphics.beginBitmapFill(_bmd, null, false);
			graphics.drawRect(0, 0, _cornerWidth, _cornerHeight);
			graphics.endFill();

			// TC
			graphics.beginBitmapFill(_tcBmd, null, true);
			graphics.drawRect(_cornerWidth, 0, frame.width - _cornerWidth * 2, _cornerHeight);
			graphics.endFill();

			// TR
			mat.tx = frame.width - _cornerWidth - _bmd.width + _cornerWidth;
			graphics.beginBitmapFill(_bmd, mat, false);
			graphics.drawRect(frame.width - _cornerWidth, 0, _cornerWidth, _cornerHeight);

			// CL ==================================================
			mat.tx = 0;
			mat.d = frame.height / _bmd.height;
			graphics.beginBitmapFill(_clBmd, mat, true);
			graphics.drawRect(0, _cornerHeight, _cornerWidth, frame.height - _cornerHeight * 2);
			graphics.endFill();

			// CC
			mat.tx = 0;
			graphics.beginBitmapFill(_ccBmd, mat, false);
			graphics.drawRect(_cornerWidth, _cornerHeight, frame.width - _cornerWidth * 2, frame.height - _cornerHeight * 2);
			graphics.endFill();

			// CR
			mat.tx = frame.width - _cornerWidth + _cornerWidth;
			mat.ty = _cornerHeight;
			
			graphics.beginBitmapFill(_crBmd, mat, true);
			graphics.drawRect(frame.width - _cornerWidth, _cornerHeight, _cornerWidth, frame.height - _cornerHeight * 2);
			graphics.endFill();

			// BL ==================================================
			mat.tx = 0;
			mat.a = mat.d = 1;
			mat.ty = frame.height - _cornerHeight - _bmd.height + _cornerHeight;
			graphics.beginBitmapFill(_bmd, mat, false);
			graphics.drawRect(0, frame.height - _cornerHeight, _cornerWidth, _cornerHeight);
			graphics.endFill();

			// BC
			mat.ty = frame.height - _cornerHeight;
			graphics.beginBitmapFill(_bcBmd, mat, false);
			graphics.drawRect(_cornerWidth, frame.height - _cornerHeight, frame.width - _cornerWidth * 2, _cornerHeight);
			graphics.endFill();

			// BR
			mat.tx = frame.width - _cornerWidth - _bmd.width + _cornerWidth;
			mat.ty = frame.height - _cornerHeight - _bmd.height + _cornerHeight;
			graphics.beginBitmapFill(_bmd, mat, false);
			graphics.drawRect(frame.width - _cornerWidth, frame.height - _cornerHeight, _cornerWidth, _cornerHeight);
		}


	}
}
