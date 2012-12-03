package blocks{
	
	
	
	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import engine.Label;
	import flash.sensors.Accelerometer;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	
	
	// КЛАСС - СТРОКА СОСТОЯНИЯ
	public class StatusBar extends Block {
		
		
		
		// СВОЙСТВА КЛАССА
		private var _textFormat:TextFormat;
		private var _label:Label;
		
		
		
		// КОНСТРУКТОР КЛАССА
		public function StatusBar() {
			super(true);
		}
		
		
		
		// КОНФИГ ЗАГРУЖЕН
		override protected function _configLoaded ():void {
			// ДОБАВЛЯЕМ ФОН
			this._addBackground	(	this._configuration['width'],
									this._configuration['height'],
									this._configuration['bgColor'],
									this._configuration['bgAlpha']
								);
			// СОЗДАЕМ ТЕКСТОВЫЙ ФОРМАТ
			this._textFormat = new TextFormat	(	this._configuration['fontFamily'],
													this._configuration['fontSize'],
													this._configuration['fontColor']
												);
			// ПРИВЕТСТВЕННАЯ НАДПИСЬ
			this._print('Трэк не выбран');
			// ПРИ СМЕНЕ ТРЕКА ОБНОВЛЯЕМ ТЕКСТ
			if ( Block._eventDispatcher != null ) {
				Block._eventDispatcher.addEventListener('TRACK_STARTED',_trackStarted);
			}
		}
		
		
		
		// ТРЕК ЗАПУЩЕН
		private function _trackStarted (_event:Event):void {
			this._print(Block._tracks[Block._trackCurrent][1]);
		}
		
		
		
		// ОБНОВИТЬ ТЕКСТ СТРОКИ СОСТОЯНИЯ
		public function _print (_message:String):void {
			// ЕСЛИ ЕСТЬ НАДПИСЬ, УДАЛЯЕМ ЕЕ
			if ( this.getChildByName( 'Label' ) ) {
				this.removeChild( this.getChildByName( 'Label' ) );				
			}
			// СОЗДАЕМ НОВУЮ НАДПИСЬ
			this._label = new Label	(	this._configuration['width'] - 10,		// ШИРИИНА
										20,										// ВЫСОТА
										_message,								// ТЕКСТ
										this._textFormat,						// ФОРМАТ ТЕКСТА
										false,									// МОЖНО ВЫДЕЛИТЬ
										false,									// ФОН НАДПИСИ
										0x000000,								// ЦВЕТ ФОНА
										0,										// ПРОЗРАЧНОСТЬ ФОНА
										false,									// РАМКА
										0x000000,								// ЦВЕТ РАМКИ
										0,										// ТОЛЩИНА РАМКИ
										3										// АКТИВАЦИЯ ПРОКРУТКИ: АВТОМАТИЧЕСКАЯ
									);
			// ДВИГАЕМ НАДПИСЬ
			this._label.x = 5;
			this._label.y = -1;
			// ИМЕНУЕМ НАДПИСЬ
			this._label.name = 'Label';
			// ДОБАВЛЯЕМ В ТАБЛИЦУ ОТОБРАЖЕНИЯ
			this.addChild(this._label);
		}
	}
}