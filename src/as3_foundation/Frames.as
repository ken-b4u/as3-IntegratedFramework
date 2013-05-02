package as3_foundation
{
	
	public class Frames
	{
		public function Frames(numFrames:int, f:Function) {
			var cnt:int = 0;
			DisplayLink.instance.addEventListener(DisplayLinkEvent.DISPLAY_UPDATE, function():void {
				f.call(this, cnt);
				if (++cnt == numFrames) DisplayLink.instance.removeEventListener(DisplayLinkEvent.DISPLAY_UPDATE, arguments.callee);
			});
		}
	}
}