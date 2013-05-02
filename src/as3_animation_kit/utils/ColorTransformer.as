package as3_animation_kit.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import as3_animation_kit.IEasing;
	import as3_animation_kit.NumericalInterpolator;

	public class ColorTransformer
	{
		private var _target:DisplayObject;
		private var _ctfm:ColorTransform = new ColorTransform();
		private var _interpR:NumericalInterpolator;
		private var _interpG:NumericalInterpolator;
		private var _interpB:NumericalInterpolator;
		private var _interpA:NumericalInterpolator;
		private var _interpRO:NumericalInterpolator;
		private var _interpGO:NumericalInterpolator;
		private var _interpBO:NumericalInterpolator;
		private var _interpAO:NumericalInterpolator;
		private var _interp:NumericalInterpolator;
		
		public function ColorTransformer(target:DisplayObject, from:ColorTransform, to:ColorTransform, easing:IEasing, step:int = 20)
		{
			_target = target;
			
			if (to.redMultiplier != from.redMultiplier) _interpR = new NumericalInterpolator(to.redMultiplier, from.redMultiplier, step, easing);
			if (to.greenMultiplier != from.greenMultiplier)_interpG = new NumericalInterpolator(to.greenMultiplier, from.greenMultiplier, step, easing);
			if (to.blueMultiplier != from.blueMultiplier)_interpB = new NumericalInterpolator(to.blueMultiplier, from.blueMultiplier, step, easing);
			if (to.alphaMultiplier != from.alphaMultiplier)_interpA = new NumericalInterpolator(to.alphaMultiplier, from.alphaMultiplier, step, easing);
			if (to.redOffset != from.redOffset) _interpRO = new NumericalInterpolator(to.redOffset, from.redOffset, step, easing);
			if (to.greenOffset != from.greenOffset) _interpGO = new NumericalInterpolator(to.greenOffset, from.greenOffset, step, easing);
			if (to.blueOffset != from.blueOffset)_interpBO = new NumericalInterpolator(to.blueOffset, from.blueOffset, step, easing);
			if (to.alphaOffset != from.alphaOffset)_interpAO = new NumericalInterpolator(to.alphaOffset, from.alphaOffset, step, easing);
			
			if (_interpR) _interp = _interpR;
			else if (_interpG) _interp = _interpG;
			else if (_interpB) _interp = _interpB;
			else if (_interpA) _interp = _interpA;
			else if (_interpRO) _interp = _interpRO;
			else if (_interpGO) _interp = _interpGO;
			else if (_interpBO) _interp = _interpBO;
			else if (_interpAO) _interp = _interpAO;
			if (_interp) _target.addEventListener(Event.ENTER_FRAME, transition);
		}
		
		public function cancel():void {
			_target.removeEventListener(Event.ENTER_FRAME, transition);
		}
		
		private function transition(e:Event):void
		{
			if (_interpR) _ctfm.redMultiplier = _interpR.next(); 
			if (_interpG) _ctfm.greenMultiplier = _interpG.next();
			if (_interpB) _ctfm.blueMultiplier = _interpB.next();
			if (_interpA) _ctfm.alphaMultiplier = _interpA.next();
			if (_interpRO) _ctfm.redOffset = _interpRO.next();
			if (_interpGO) _ctfm.greenOffset = _interpGO.next();
			if (_interpBO) _ctfm.blueOffset = _interpBO.next();
			if (_interpAO) _ctfm.alphaOffset = _interpAO.next();
			_target.transform.colorTransform = _ctfm;
			
			if (_interp.isEnd)
			{
				_target.removeEventListener(Event.ENTER_FRAME, transition);
				_interpR = null;
				_interpG = null;
				_interpB = null;
			}
		}
	}
}