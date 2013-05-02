package as3_foundation.storage
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import as3_user_interface_kit.log.Logger;

	public class DesktopApplicationStrage
	{
		private var _fileName:String;
		private var _config:File;
		private var _fileContent:String = "";
		private static const CONF_ENCODING:String = "UTF-8";
		
		public function DesktopApplicationStrage(confName:String, fileExtension:String)
		{
			_fileName = confName + "." + fileExtension;
			_config = File.applicationStorageDirectory.resolvePath(_fileName);
			Logger.instance().info("create a file at " + _config.nativePath);
			
			if (_config.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(_config, FileMode.READ);
				_fileContent = fs.readMultiByte(_config.size, CONF_ENCODING);
				fs.close();
			}
			else
			{
				save();
			}
		}
		
		public function save():void
		{
			var fs:FileStream = new FileStream();
			fs.open(_config, FileMode.WRITE);
			fs.writeMultiByte(_fileContent, CONF_ENCODING);
			fs.close();
		}
		
		public function get fileContent():String
		{
			return _fileContent;
		}
		
		public function set fileContent(content:String):void
		{
			_fileContent = content;
		}
	}
}