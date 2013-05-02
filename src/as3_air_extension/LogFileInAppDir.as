package as3_foundation.log
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class LogFileInAppDir implements IPrintable
	{
		private var _logFile:File;
		private var _fileContent:String = "";
		private static const CONF_ENCODING:String = "UTF-8";
		
		
		public function LogFileInAppDir(fileName:String, fileExtention:String)
		{
			fileName += "." + fileExtention;
			
			_logFile = File.applicationStorageDirectory.resolvePath(fileName);
			if (!_logFile.exists)
				save();
			else
			{
				var fs:FileStream = new FileStream();
				fs.open(_logFile, FileMode.READ);
				_fileContent = fs.readMultiByte(_logFile.size, CONF_ENCODING);
				fs.close();
			}
		}
		
		public function save():void
		{
			var fs:FileStream = new FileStream();
			fs.open(_logFile, FileMode.WRITE);
			fs.writeMultiByte(_fileContent, CONF_ENCODING);
			fs.close();
		}
		
		public function print(characters:String):void
		{
			_fileContent += characters;
			save();
		}
	}
}