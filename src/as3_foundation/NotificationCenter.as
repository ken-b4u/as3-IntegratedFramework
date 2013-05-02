package as3_foundation
{
	

	/**
	 * 通知センター。
	 *
	 * <p>シングルトンクラスです。</p>
	 * <p>下記のような感じで使用します。</p>
	 * <listing>
	 * // 通知監視側
	 * NotificationCenter.instance().addObserver(this, notification, "sceneChange");
	 *
	 * // 通知発行側
	 * var notificationObject:Notification = new Notification( "sceneChange", sceneID );
	 * NotificationCenter.instance().postNotification( notificationObject );
	 * </listing>
	 *
	 * <code>postNotification</code>が呼び出されたとき、その引数に渡された<code>Notification</code>インスタンスの通知名を監視しているオブジェクトに一斉に通知されます。
	 * <code>NotificationCenter</code>インスタンスの<code>addObserver()</code>を使用して通知対象リストにオブジェクトを追加します。
	 *
	 * @author takanosatoshi
	 * @see Notification
	 */
	public class NotificationCenter
	{
		private static var _singletonInstance:NotificationCenter;
		private var _targets:Object;

		/**
		 * @private
		 * @param enforcer
		 *
		 */
		public function NotificationCenter(enforcer:SingletonEnforcer):void
		{
			_targets = {};
		}

		/**
		 * シングルトンなインスタンスを返します.
		 * @return
		 *
		 */
		public static function instance():NotificationCenter
		{
			if (_singletonInstance == null)
				_singletonInstance = new NotificationCenter(new SingletonEnforcer());
			return _singletonInstance;
		}

		/**
		 * 通知対象オブジェクトを登録します.
		 *
		 * @param target 通知を受けるターゲット
		 * @param func 通知を受け取った時に呼ばれるメソッド
		 * @param name 監視する通知名
		 *
		 */
		public function addObserver(target:*, name:String, func:Function):void
		{
			var obj:NotificationTarget = new NotificationTarget(target, func);
			var isAlreadyPushed:Boolean = false;
			if (!_targets.hasOwnProperty(name))
				_targets[name] = [];
			var list:Array = _targets[name];
			var l:int = list.length;

			for (var i:int = 0; i < l; i++)
			{
				var already:NotificationTarget = list[i];
				if (obj.target == already.target && already.func == func)
				{
					isAlreadyPushed = true;
				}
			}
			if (!isAlreadyPushed)
			{
				list.push(obj);
			}
		}
		
		public function removeObserver(target:*, name:String, func:Function):void
		{
			var list:Array = _targets[name];
			var numTargets:int = list.length;
			for (var i:int = 0; i < numTargets; i++)
			{
				var already:NotificationTarget = list[i];
				if (already.target === target && already.func === func)
				{
					list.splice(i, 1);	
					return;
				}
			}
		}

		/**
		 * 通知を発行します.
		 * @param notification
		 *
		 */
		public function postNotification(notification:Notification):void
		{
			var list:Array = _targets[notification.name];
			if (list == null)
				return;
			var l:int = list.length;
			for (var i:int = 0; i < l; i++)
			{
				var obj:NotificationTarget = list[i];
				try {
					obj.func.call(obj.target, notification);
				} catch (e:Error) {
					try {
						obj.func.call(obj.target, notification.object);
					} catch (e:Error) {
						try {
//							trace(e);
							obj.func.call(obj.target);
						} catch (e:Error) {
	//						trace(e);
						}
					}
				}
			}
		}
		
	}
}

/**
 * @private
 * @author tkn
 *
 */
internal class SingletonEnforcer
{
}

/**
 * @private
 * @author tkn
 *
 */
internal class NotificationTarget
{
	public var target:*;
	public var func:Function;

	public function NotificationTarget(target:*, func:Function):void
	{
		this.target = target;
		this.func = func;
	}
}