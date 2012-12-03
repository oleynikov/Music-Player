package engine {
	// ИМПОРТ ПАКЕТОВ
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	// КЛАСС - ЗАГРУЗЧИК XML ФАЙЛОВ
	public class XmlLoader {
		// СВОЙСТВА КЛАССА
		static public var _eventXmlParsed:Event;
		private var _urlLoader:URLLoader;
		private var _xml:XML;
		public var _eventDispatcher:EventDispatcher;
		// КОНСТРУКТОР
		public function XmlLoader(_url:String):void {
			// СОЗДАЕМ СВОЙСТВА
			XmlLoader._eventXmlParsed = new Event('XML_PARSED');
			this._eventDispatcher = new EventDispatcher();
			// ОТПРАВЛЯЕМ ЗАПРОС
			var _urlRequest:URLRequest = new URLRequest(_url);
			this._urlLoader = new URLLoader(_urlRequest);
			this._urlLoader.addEventListener(Event.COMPLETE,_xmlLoaded);
		}
		private function _xmlLoaded (_event:Event):void {
			this._xml = new XML(this._urlLoader.data);
			this._eventDispatcher.dispatchEvent(XmlLoader._eventXmlParsed);
		}
		public function get _getXml ():XML{
			return this._xml;
		}
	}
}