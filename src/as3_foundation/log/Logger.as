package as3_foundation.log
{
	import as3_foundation.Notification;
	import as3_foundation.NotificationCenter;

	/**
	 * レベル別ログ出力用のユーティリティです。
	 */
	public class Logger
	{
		private var _logLevel:int = LogLevel.DEBUG;
		private static var _instance:Logger;
		private var _ostream:IPrintable;

		private var _className:String;

		private var _oldTime:Number;




		/**
		 * @private
		 */
		public function Logger(si:SingletonEnforcer)
		{
			_ostream = StdOut.instance();
		}

		/**
		 * インスタンスを返します.
		 * @return
		 *
		 */
		public static function instance():Logger
		{
			if (_instance == null)
				_instance = new Logger(new SingletonEnforcer());
			return _instance;
		}

		/**
		 * 出力先です.
		 * @return
		 *
		 */
		public function get ostream():IPrintable
		{
			return _ostream;
		}

		public function set ostream(ost:IPrintable):void
		{
			_ostream = ost;
		}

		/**
		 * ログレベルを設定します.
		 * <pre>
		 * DEBUG:Number = 4;
		 * INFO:Number = 3;
		 * WARN:Number = 2;
		 * ERROR:Number = 1;
		 * FATAL:Number = 0;
		 * NONE:Number = -1;
		 * </pre>
		 * @param logLevel
		 *
		 */
		public function set logLevel(logLevel:int):void
		{
			_logLevel = logLevel;
			var notif:Notification = new Notification("changeLogLevel", this);
			NotificationCenter.instance().postNotification(notif);
		}
		
		public function get logLevel():int
		{
			return _logLevel;
		}

		/**
		 * DEBUG レベルで出力します.
		 * @param arguments
		 *
		 */
		public function debug(... arguments):void
		{
			if (_logLevel >= LogLevel.DEBUG)
			{
				log(LogLevel.getModeString(LogLevel.DEBUG) + " " + arguments);
			}
		}

		/**
		 * INFO レベルで出力します.
		 * @param arguments
		 *
		 */
		public function info(... arguments):void
		{
			if (_logLevel >= LogLevel.INFO)
			{
				log(LogLevel.getModeString(LogLevel.INFO) + " " + arguments);
			}
		}

		/**
		 * WARN レベルで出力します.
		 * @param arguments
		 *
		 */
		public function warn(... arguments):void
		{
			if (_logLevel >= LogLevel.WARN)
			{
				log(LogLevel.getModeString(LogLevel.WARN) + " " + arguments);
			}
		}

		/**
		 * ERROR レベルで出力します。
		 * @param arguments
		 *
		 */
		public function error(... arguments):void
		{
			if (_logLevel >= LogLevel.ERROR)
			{
				log(LogLevel.getModeString(LogLevel.ERROR) + " " + arguments);
			}
		}

		/**
		 * 実行時間計測を開始します.
		 *
		 */
		private var _stampCount:int = 0;
		public function startPerformanceTest():void
		{
			_stampCount = 0;
			_oldTime = new Date().getTime();
		}

		public function stamp():void
		{
			log((++_stampCount).toString() + " : " + (new Date().getTime() - _oldTime) / 1000);
		}
		
		/**
		 * 実行時間計測を停止して、経過時間を msec 単位で出力します.
		 *
		 */
		public function stopPerformanceTest():void
		{
			log("end " + (new Date().getTime() - _oldTime) / 1000);
		}

		/**
		 * @private
		 * @param arguments
		 *
		 */
		private function log(... arguments):void
		{
			if (_logLevel > LogLevel.NONE)
			{
				_ostream.print(arguments.toString());
			}
		}

	}
}

internal class SingletonEnforcer
{
}