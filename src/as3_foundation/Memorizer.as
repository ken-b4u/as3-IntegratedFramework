package as3_foundation
{
	public class Memorizer
	{
		var _mem:Array;
		public function Memorizer()
		{
			_mem = new Array();
		}
		
		public function getObject(id:Identifierable):Object
		{
			var numObj:int = _mem.length;
			for (var i:int = 0; i < numObj; i++)
			{
				if (_mem[i].id == id)
					return _mem[i];
			}
			return null;
		}
		
		public function addObjec(obj:Identifierable):void
		{
			var numObj:int = _mem.length;
			var yet:Boolean = true;
			for (var i:int = 0; i< numObj; i++)
			{
				if (_mem[i].id == obj.id)
					yet = false;
			}
			if (yet)
				_mem.push(obj);
		}
	}
}