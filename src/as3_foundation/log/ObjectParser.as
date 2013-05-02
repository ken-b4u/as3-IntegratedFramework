package as3_foundation.log
{
	
	public class ObjectParser
	{
		public function ObjectParser()
		{
			throw new Error("インスタンスを作成できません");
		}
		
		public static function parse(obj:Object, indent:int = 2):String
		{
			var res:String = "";
			var space:String = "";
			for (var i:int = 0; i < indent; i++)
				space += " ";
			
			for (var key:String in obj) {
				res += space + key + " : ";
				switch (typeof obj[key]) {
					case "string":
					case "number":
						res += obj[key] + "\n";
						break;
					case "object":
						res += parse(obj[key], indent + indent) + "\n";
						break;
					default:
						
						break;
				}
				
			}
			return res;
		}
	}
}