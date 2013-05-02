package as3_audio_visual_kit
{
	import as3_user_interface_kit.controllers.ViewController;
	
	public class MovieGroupController extends ViewController
	{
		private var _movies:Vector.<FLV>;
		private var _activeFLV:FLV;
		private var _currentMovieIndex:int = -1;
		
		public function MovieGroupController(flvs:Vector.<FLV> = null)
		{
			super();
			_movies = flvs;
			if (_movies == null) _movies = new Vector.<FLV>();
			for each (var flv:FLV in _movies) {
				view.addChild(flv);
				flv.visible = false;
			}
			_activeFLV = _movies[0];
			_activeFLV.visible = true;
			_currentMovieIndex = 0;
		}
		
		public function next():void {
			play(++_currentMovieIndex);
		}
		
		public function prev():void {
			if (_currentMovieIndex == 0) {
				
			}
			else play(--_currentMovieIndex);
		}
		
		public function play(movieIndex:int):void {
			if (_activeFLV) {
				if (_activeFLV.playing) _activeFLV.stop();
				_activeFLV.visible = false;
			}
			
			var newm:FLV = _movies[movieIndex];
			if (_activeFLV) {
				newm.x = _activeFLV.x;
				newm.y = _activeFLV.y;
				newm.width = _activeFLV.width;
				newm.height = _activeFLV.height;
			}
			_activeFLV = newm;
			_activeFLV.visible = true;
			_activeFLV.play();
			_currentMovieIndex = movieIndex;
		}
		
		public function pause():void {
			_activeFLV.pause();
		}
		
		public function resume():void {
			if (!_activeFLV.arrivalEnd) {
				if (!_activeFLV.playing) _activeFLV.resume();
			}
			else next();
		}
		
		public function stop():void {
			_activeFLV.stop();
			_activeFLV.visible = false;
			_currentMovieIndex = 0;
			_activeFLV = _movies[_currentMovieIndex];
			_activeFLV.visible = true;
		}

		public function get currentMovieIndex():int
		{
			return _currentMovieIndex;
		}
		
		public function get currentActiveMovie():FLV {
			return _activeFLV;
		}

		protected function get movies():Vector.<FLV>
		{
			return _movies;
		}
	
		public function get duration():Number {
			var d:Number = 0;
			for each(var m:FLV in _movies) {
				d += m.duration;
			}
			return d;
		}
		
		public function get time():Number {
			var t:Number = 0;
			for each(var m:FLV in _movies) {
				if (_activeFLV == m) {
					t += m.time;
					break;
				} else {
					t += m.duration;
				}
			}
			return t;
		}
		
	}
}