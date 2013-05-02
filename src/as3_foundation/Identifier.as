package as3_foundation
{
	public class Identifier
	{
		private var _id:int;
		private static var _ids:Array = new Array();
		
		public function Identifier()
		{
			_id = (new Date()).time;
			while (!check())
				_id = _id * Math.random();
			_ids.push(_id);
		}
		
		private function check():Boolean
		{
			var numIDs:int = _ids.length;
			var res:Boolean = true;
			for (var i:int = 0; i < numIDs; i++)
			{
				if (_ids[i] == _id)
					res = false;
			}
			return res;
		}
		
		public function toString():String
		{
			return _id.toString();
		}
	}
}