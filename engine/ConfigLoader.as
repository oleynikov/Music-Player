package engine {
	// ИМПОРТ ПАКЕТОВ
	import engine.XmlLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLDocument;
	// КЛАСС ЗАГРУЗЧИК КОНФИГА
	public class ConfigLoader {
		// СВОЙСТВА КЛАССА
		static public var _eventConfigurationParsed:Event;
		private var _xmlLoader:XmlLoader;
		public var _configuration:Array;
		public var _eventDispatcher:EventDispatcher;
		// КОНСТРУКТОР
		public function ConfigLoader(_url:String):void {
			// СОЗДАЕМ СВОЙСТВА
			ConfigLoader._eventConfigurationParsed = new Event('CONFIG_PARSED');
			this._eventDispatcher = new EventDispatcher();
			this._configuration = new Array();
			// ОТПРАВЛЯЕМ ЗАПРОС
			this._xmlLoader = new XmlLoader(_url);
			this._xmlLoader._eventDispatcher.addEventListener(XmlLoader._eventXmlParsed.type,_arraysFill);
		}
		private function _arraysFill(_event:Event):void {
			var _сounter:uint = new uint();
			var _parameters:XMLList = this._xmlLoader._getXml.child('p');
			var _paramLength:uint = _parameters.length();
			var _counter:uint = new uint();
			for (_counter; _counter < _paramLength; _counter ++){
				var _parameterName:String = _parameters.attribute('n')[_counter];
				var _parameterValue:String = _parameters.attribute('v')[_counter];
				this._configuration[_parameterName] = _parameterValue;
			}
			this._eventDispatcher.dispatchEvent(ConfigLoader._eventConfigurationParsed);
		}
	}
}