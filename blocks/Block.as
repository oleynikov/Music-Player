package blocks  {



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import engine.ConfigLoader;
	import flash.utils.getQualifiedClassName;
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.events.IOErrorEvent;



	// КЛАСС - РОДИТЕЛЬ ВСЕХ ЭЛЕМЕНТОВ ПЛЕЕРА
	public class Block extends Sprite {
		
		
		
		// СВОЙСТВА КЛАССА
		protected var _configLoader:ConfigLoader;				// ЗАГРУЗЧИК КОНФИГА
		protected var _configuration:Array;						// МАССИВ СО ВСЕМИ ПАРАМЕТРАМИ КОНФИГУРАЦИИ
		protected static var _tracks:Array;						// ВСЕ ТРЭКИ
		protected static var _sound:Sound;						// ЗВУКОВОЙ ОБЪЕКТ
		protected static var _soundChannel:SoundChannel;		// ЗВУКОВОЙ КАНАЛ
		protected static var _soundTransform:SoundTransform;	// ТРАНСФОРМАЦИЯ ЗВУКА
		protected static var _trackCurrent:uint;				// ТЕКУЩИЙ ТРЭК
		protected static var _trackPositionCurrent:Number;		// СЕКУНДА ТЕКУЩЕГО ТРЭКА
		protected static var _trackIsPlaying:Boolean;			// ТРЭК СЕЙЧАС ПРОИГРЫВАЕТСЯ
		protected static var _trackIsPaused:Boolean;			// ТРЭК СЕЙЧАС НА ПАУЗЕ
		protected static var _loopEnabled:Boolean;				// Зацикливание включено
		protected static var _eventDispatcher:EventDispatcher;	// ДИСПЕТЧЕР СОБЫТИЙ
		
		
		
		// КОНСТРУКТОР КЛАССА
		public function Block(_useConfig:Boolean):void {
			
			
			
			
			// ЕСЛИ НАСЛЕДНИК ИСПОЛЬЗУЕТ КОНФИГ, ЗАГРУЖАЕМ ЕГО
			if (_useConfig){
				// ОПРЕДЕЛЯЕМ ТИП КЛАССА
				var _blockType:String;
					_blockType = getQualifiedClassName(this);
					_blockType = _blockType.replace('::','-');
				// ЗАГРУЖАЕМ ФАЙЛ КОНФИГУРАЦИИ
				this._configLoader = new ConfigLoader('config/' + _blockType + '.xml');
				this._configLoader._eventDispatcher.addEventListener(ConfigLoader._eventConfigurationParsed.type,_blockDraw);
			}
			// ЕСЛИ КОНФИГ НЕ НУЖЕН, СРАЗУ ВЫПОЛНЯЕМ КОНСТРУКТОР
			else{
				this._configLoaded();
			}
		}
		
		
		
		// КОНФИГ ЗАГРУЖЕН, ВЫПОЛНЯЕМ КОНСТРУКТОР
		private function _blockDraw (_event:Event):void {
			// СЧИТЫВАЕМ ЗНАЧЕНИЯ ИЗ ФАЙЛА КОНФИГУРАЦИИ
			this._configuration = this._configLoader._configuration;
			this._configLoaded();
		}
		
		
		
		// МОДИФИЦИРОВАННЫЙ КОНСТРУКТОР КЛАССА
		protected function _configLoaded ():void {
			;
		}
		
		
		
		// ДОБАВИТЬ МАСКУ К КОМПОНЕНТУ
		protected function _addMask	(	__width:Number,
									 	__height:Number
									):void {
			var __mask:Shape = new Shape();
				__mask.graphics.beginFill(0x000000,1);
				__mask.graphics.drawRect(0,0,__width,__height);
				__mask.graphics.endFill();
			this.addChild(__mask);
			this.mask = __mask;
		}
		
		
		
		// ДОБАВИТЬ ФОН К КОМПОНЕНТУ
		protected function _addBackground	(	__width:Number,
									 			__height:Number,
												__color:uint,
												__alpha:Number
											):void {
			var _background:Shape = new Shape();
				_background.graphics.beginFill(__color,__alpha);
				_background.graphics.drawRect(0,0,__width,__height);
				_background.graphics.endFill();
			this.addChild(_background);
		}
		
		
		
		// ЗАПУСТИТЬ ФАЙЛ
		protected function _trackPlay (_trackNumber:uint,_trackPosition:Number):void{
			var _soundRequest:URLRequest = new URLRequest(Block._tracks[_trackNumber][0]);
			Block._sound = new Sound(_soundRequest);
			Block._sound.addEventListener (IOErrorEvent.IO_ERROR,_ioError);
			Block._soundChannel.stop();
			Block._eventDispatcher.dispatchEvent(new Event('TRACK_STOPPED'));
			Block._soundChannel = Block._sound.play(_trackPosition,1);
			Block._soundChannel.soundTransform = Block._soundTransform;
			Block._soundChannel.addEventListener(Event.SOUND_COMPLETE,_soundComplete);
			Block._trackCurrent = _trackNumber;
			Block._trackIsPlaying = true;
			Block._trackIsPaused = false;
			Block._eventDispatcher.dispatchEvent(new Event('TRACK_STARTED'));
		}
		
		protected function _ioError (_event:IOErrorEvent):void {
		
		}

		
		// ОСТАНОВИТЬ ФАЙЛ
		protected function _trackStop ():void{
			Block._soundChannel.stop();
			Block._trackIsPlaying = false;
			Block._trackIsPaused = false;
		}
		
		
		
		// ТРЭК ПРОИГРАН
		private function _soundComplete (_event:Event):void {
			if ( Block._loopEnabled ) {
				this._trackPlay ( Block._trackCurrent , 0 );
			}
			else {
				this._trackPlay ( Block._trackCurrent + 1 , 0 );
			}
		}
	}
}