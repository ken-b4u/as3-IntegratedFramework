package as3_foundation
{

	public class Timestamp
	{
		private var _wasCreateAt:Date;
		private var _stampID:int = 0;

		public function Timestamp()
		{
			_wasCreateAt = new Date;
		}

		public function toString():String
		{
			var str:String = "◆Timestamp : " + getTimestamp() + " msec (elapsed from creation)";
			return str;
		}

		public function getDetail():String
		{
			var str:String = "◆Timestamp ID : " + _stampID++;
			str += "\n-creation at : " + _wasCreateAt;
			str += "\n-elapsed from creation : " + getTimestamp() + " msec";
			return str;
		}

		private function getTimestamp():Number
		{
			return (new Date().getTime() - _wasCreateAt.getTime());
		}
	}
}