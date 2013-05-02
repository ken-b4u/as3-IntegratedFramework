package as3_foundation.log
{
	public class LogLevel
	{
		public static const DEBUG:Number = 4;
		public static const INFO:Number = 3;
		public static const WARN:Number = 2;
		public static const ERROR:Number = 1;
		public static const FATAL:Number = 0;
		public static const NONE:Number = -1;
		
		public static function getModeString(level:int):String
		{
			switch(level)
			{
				case DEBUG: return "[DEBUG]";
				case INFO: return "[INFO]";
				case WARN: return "[WARN]";
				case ERROR: return "[ERROR]";
				case NONE: return "";
			}
			return null;
		}
	}
}