package blocks{



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import engine.CollapsableContainer;
	import engine.ScrollingContainer;
	import blocks.PlaylistButton;
	import engine.ContainerEvent;
	import engine.XmlLoader;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.events.EventDispatcher;



	// КЛАСС - ПЛЕЙЛИСТ
	public class Playlist extends Block {
		
		
		
		// СВОЙСТВА КЛАССА
		private var _scrollingContainer:ScrollingContainer;		// ПРОКРУЧИВАЕМЫЙ КОНТЕЙНЕР
		private var _playlistLoader:XmlLoader;					// ЗАГРУЗЧИК ПЛЕЙЛИСТА
		private var _depthCurrent:uint;							// ТЕКУЩАЯ ГЛУБИНА
		private var _positionCurrent:uint;						// ТЕКУЩАЯ ПОЗИЦИЯ НА УРОВНЕ
		private var _pathCurrent:Array;							// ТЕКУЩИЙ ПУТЬ
		private var _folders:Array;								// ВСЕ ПАПКИ
		private var _textFormat:TextFormat;						// ФОРМАТ ТЕКСТА
		
		
		
		// КОНСТРУКТОР КЛАССА
		public function Playlist ():void {
			super(true);
		}
		
		
		
		// КОНФИГ ЗАГРУЖЕН
		override protected function _configLoaded ():void {
			// СОЗДАЕМ СТАТИЧЕСКИЕ СВОЙСТВА КЛАССА
			Block._tracks  = new Array();
			Block._sound = new Sound();
			Block._soundChannel = new SoundChannel();
			Block._soundTransform = new SoundTransform(0.5,0);
			Block._trackCurrent = new uint();
			Block._trackPositionCurrent = new Number();
			Block._trackIsPlaying = new Boolean(false);
			Block._trackIsPaused = new Boolean(false);
			Block._loopEnabled = new Boolean(false);
			Block._eventDispatcher = new EventDispatcher();			
			// СОЗДАЕМ СВОЙСТВА КЛАССА
			this._textFormat = new TextFormat	(	this._configuration['fontFamily'],
													this._configuration['fontSize'],
												 	this._configuration['fontColor']
												);
			// РИСУЕМ ФОН
			this._addBackground	(	this._configuration['width'],
								 	this._configuration['height'],
								 	this._configuration['bgColor'],
								 	this._configuration['bgAlpha']
								 );
			// ЗАГРУЖАЕМ ПЛЕЙЛИСТ
			this._playlistLoader = new XmlLoader('playlist/playlist.xml');
			this._playlistLoader._eventDispatcher.addEventListener('XML_PARSED',_playlistRead);
			
			Block._eventDispatcher.addEventListener('TRACK_STOPPED',_trackPathHide);
			Block._eventDispatcher.addEventListener('TRACK_STARTED',_trackPathShow);
		}
		
		
		
		// ПОКАЗЫВАЕМ ПУТЬ К ПРОИГРЫВАЕМОМУ ФАЙЛУ
		
		private function _trackPathShow(_event:Event):void {
			var _track = Block._tracks[Block._trackCurrent];
			var _parentDepth = _track[2];
			var _parentPosition = _track[3];
			_track[4]._iconChange(new TrackSelected());
			_pathShow(_parentDepth,_parentPosition);
		}
		private function _trackPathHide(_event:Event):void {
			var _track = Block._tracks[Block._trackCurrent];
			var _parentDepth = _track[2];
			var _parentPosition = _track[3];
			_track[4]._iconChange(new Track());
			_pathHide(_parentDepth,_parentPosition);
		}
		private function _pathShow (_depth:uint,_position:uint):void {
			var _folder = this._folders[_depth][_position];
			var _folderSprite = _folder['sprite'];
			var _folderOpened = _folder['sprite']._opened;
			var _folderHead = _folderSprite._head.getChildByName('Head');
			var _folderParentDepth = _folder['parentDepth'];
			var _folderParentPosition = _folder['parentPosition'];
			if ( _folderHead ) {
				if ( _folderOpened ) {
					_folderHead._iconChange(new FolderOpenedSelected());
				}
				else {
					_folderHead._iconChange(new FolderClosedSelected());
				}
				_folderSprite._selected = true;
				_pathShow(_folderParentDepth,_folderParentPosition);
			}
		}


		
		private function _pathHide (_depth:uint,_position:uint):void {
			var _folder = this._folders[_depth][_position];
			var _folderSprite = _folder['sprite'];
			var _folderOpened = _folder['sprite']._opened;
			var _folderHead = _folderSprite._head.getChildByName('Head');
			var _folderParentDepth = _folder['parentDepth'];
			var _folderParentPosition = _folder['parentPosition'];
			if ( _folderHead ) {
				if ( _folderOpened ) {
					_folderHead._iconChange(new FolderOpened());
				}
				else {
					_folderHead._iconChange(new FolderClosed());
				}
				_folderSprite._selected = false;
				_pathHide(_folderParentDepth,_folderParentPosition);
			}
		}
		
		
		
		
		
		
		// НАЧИНАЕМ СКАНИРОВАТЬ ПЛЕЙЛИСТ
		private function _playlistRead (_event:Event):void {
			this._depthCurrent = new uint();
			this._positionCurrent = new uint();
			this._pathCurrent = new Array();
			this._folders = new Array();
			_folderRead(this._playlistLoader._getXml);
		}
		
		
		
		// СКАНИРУЕМ ПАПКУ
		private function _folderRead (_currentFolderXml:XML):void {
			// НАЗВАНИЕ ЭТОЙ ПАПКИ
			var _folderName:String = _currentFolderXml.attribute('n')[0];
			// ОПРЕДЕЛЯЕМ ПОЗИЦИЮ ПАПКИ НА УРОВНЕ
			if ( this._folders[this._depthCurrent] == undefined ) {
				this._folders[this._depthCurrent] = new Array();
				this._positionCurrent = 0;
			}
			else{
				this._positionCurrent = this._folders[this._depthCurrent].length;
			}
			// СОЗДАЕМ ПАПКУ
			var _folderThis:CollapsableContainer;
			// КОРНЕВАЯ ПАПКА ОТКРЫТА, ВСЕ ОСТАЛЬНЫЕ - ЗАКРЫТЫ
			if ( this._depthCurrent == 0 ){
				_folderThis = new CollapsableContainer(true);
			}
			else{
				_folderThis = new CollapsableContainer(false);
			}
			// ВСЕ ПАПКИ НАЧИНАЯ СО ВТОРОГО УРОВНЯ СДВИГАЕМ НА 20 ПИКСЕЛОВ
			if ( this._depthCurrent > 1 ){
				_folderThis.x = 20;
			}
			// ДЛЯ ВСЕХ ПАПОК КРОМЕ НУЛЕВОГО УРОВНЯ ДОБАВЛЯЕМ ГОЛОВУ
			if ( this._depthCurrent > 0 ) {
				var _folderHead:PlaylistButton = new PlaylistButton	(	this._configuration['width'] - 20 * ( this._depthCurrent - 1  ) - 15,
																	 	20,
																		_folderName,
																		this._textFormat,
																		true
																	);
				_folderThis._depth = this._depthCurrent;			// УРОВЕНЬ ГЛУБИНЫ ЭТОЙ ПАПКИ
				_folderThis._position = this._positionCurrent;		// ПОЗИЦИЯ НА УРОВНЕ
				_folderThis._headAdd(_folderHead);					// ДОБАВЛЯЕМ ГОЛОВУ
				// СЛУШАЕМ ИЗМЕНЕНИЕ  СОСТОЯНИЯ ПАПКИ
				_folderThis._eventDispatcher.addEventListener('STATE_CHANGED',_folderStateChanged);
				// ВЫЧИСЛЯЕМ РОДИТЕЛЯ
				var _parentDepth:uint = this._depthCurrent - 1;
				var _parentPosition:uint = this._folders[_parentDepth].length - 1;
			}
			// СОЗДАЕМ МАССИВ, ЗАДАЮЩИЙ КОНКРЕТНУЮ ПАПКУ
			this._folders[this._depthCurrent][this._positionCurrent] = new Array();
			this._folders[this._depthCurrent][this._positionCurrent]['sprite'] = _folderThis;
			this._folders[this._depthCurrent][this._positionCurrent]['parentDepth'] = _parentDepth;
			this._folders[this._depthCurrent][this._positionCurrent]['parentPosition'] = _parentPosition;
			// ИЩЕМ И СКАНИРУЕМ ДОЧЕРНИЕ ПАПКИ
			this._depthCurrent ++;					// ПЕРЕХОДИМ НА ВЕРХНИЙ УРОВЕНЬ
			this._pathCurrent.push(_folderName);	// ДОБАВЛЯЕМ ИМЯ ПАПКИ К ПОЛНОМУ ПУТИ
			var _key:uint = new uint();
			var _foldersCount:uint = _currentFolderXml.child('f').length();
			for ( _key = 0 ; _key < _foldersCount ; _key ++ ){
				var _folderChild:XML = new XML(_currentFolderXml.child('f')[_key].toXMLString());
				_folderRead(_folderChild);
			}
			this._depthCurrent --;					// ПЕРЕХОДИМ НА НИЖНИЙ УРОВЕНЬ
			// ОПРЕДЕЛЯЕМ ПОЗИЦИЮ ТЕКУЩЕЙ ПАПКИ
			this._positionCurrent = this._folders[this._depthCurrent].length - 1;
			// ИЩЕМ ДОЧЕРНИЕ ФАЙЛЫ
			var _tracksCount:uint = _currentFolderXml.child('t').length();
			for ( _key = 0 ; _key < _tracksCount ; _key ++ ){
				// НАЗВАНИЕ ТРЭКА
				var _trackName:String = _currentFolderXml.child('t')[_key].attribute('n')[0];
				// СОЗДАЕМ СПРАЙТ ТРЭКА
				var _trackCurrent:PlaylistButton = new PlaylistButton	(	this._configuration['width'] - 20 * this._depthCurrent - 15,
																 			20,
																			_trackName.replace('.mp3',''),
																			this._textFormat,
																			false
																		);
				if ( this._depthCurrent == 0 ) {
					_trackCurrent.x = 0;
				}
				else {
					_trackCurrent.x = 20;
				}
				// ДОБАВЛЯЕМ ТРЭК В ПАПКУ
				this._folders[this._depthCurrent][this._positionCurrent]['sprite']._bodyAdd(_trackCurrent);
				// ДОБАВЛЯЕМ ТРЭК В МАССИВ
				Block._tracks.push	(	new Array	(	_pathMake()['full'] + _trackName,	// ПОЛНЫЙ ПУТЬ К ТРЭКУ
													 	_pathMake()['short'] + _trackName,	// КРАТКИЙ ПУТЬ К ТРЭКУ
														this._depthCurrent,					// ГЛУБИНА РОДИТЕЛЯ
														this._positionCurrent,				// ПОЗИЦИЯ РОДИТЕЛЯ
														_trackCurrent
													)
									);
				_trackCurrent._trackNumber = Block._tracks.length - 1;	// ВЫЧИСЛЯЕМ ID ТРЭКА
			}
			// УДАЛЯЕМ ИМЯ ПАПКИ ИЗ ПОЛНОГО ПУТИ
			this._pathCurrent.pop();
			// ДОБАВЛЯЕМ ОТСКАНИРОВАННУЮ ПАПКУ В РОДИТЕЛЯ
			// ЕСЛИ ПАПКА КОРНЕВАЯ, ДОБАВЛЯЕМ ЕЕ В КОРНЕВОЙ КОНТЕЙНЕР
			if ( this._depthCurrent == 0 ) {
				// СОЗДАЕМ ПРОКРУЧИВАЕМЫЙ КОНТЕЙНЕР
				this._scrollingContainer = new ScrollingContainer	(	this._configuration['width'],
																	 	this._configuration['height'],
																		0x000000,
																		0,
																 		this._folders[0][0]['sprite']
																	);
				this.addChild(this._scrollingContainer);
			}
			// ЕСЛИ ПАПКА НЕ КОРНЕВАЯ, ДОБАВЛЯЕМ ЕЕ В ТЕЛО РОДИТЕЛЯ
			else {
				this._folders[_parentDepth][_parentPosition]['sprite']._bodyAdd	(this._folders[this._depthCurrent][this._positionCurrent]['sprite']);
			}
		}
		
		
		
		// ПАПКУ ОТКРЫЛИ ЛИБО ЗАКРЫЛИ
		private function _folderStateChanged (_event:ContainerEvent):void {
			// УРОВЕНЬ ЭТОЙ ПАПКИ
			var _folderDepth:uint = _event._parameters[0];
			var _folderPosition:uint = _event._parameters[1];
			// ПАПКУ ЗАКРЫЛИ => ЗАКРЫВАЕМ ВСЕХ ДЕТЕЙ
			if ( _event._parameters[2] == 'CONTAINER_CLOSED' ) {
				this._folderClose(_folderDepth,_folderPosition);
			}
			// ПАПКУ ОТКРЫЛИ => МЕНЯЕМ ИКОНКУ
			else if ( _event._parameters[2] == 'CONTAINER_OPENED' ) {
				if ( this._folders[_folderDepth][_folderPosition]['sprite']._selected ) {
					this._folders[_folderDepth][_folderPosition]['sprite']._head.getChildByName('Head')._iconChange(new FolderOpenedSelected());
				}
				else {
					this._folders[_folderDepth][_folderPosition]['sprite']._head.getChildByName('Head')._iconChange(new FolderOpened());
				}
			}
			// ПЕРЕРИСОВЫВАЕМ ВСЕ УРОНИ НАЧИНАЯ С НАИВЫСШЕГО
			this._levelReDraw(this._folders.length - 1);
			// ОБНОВЛЯЕМ КОНТЕЙНЕР ПРОКРУТКИ
			this._scrollingContainer._contentUpdate();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		//	ПЕРЕРИСОВЫВАЕМ ВСЕ УРОВНИ ВВЕРХ ДО УПОРА
		//
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _levelReDraw(_folderDepth:uint):void {
			var _key:uint = new uint();
			var _depthLength:uint = this._folders[_folderDepth].length;
			for (_key; _key < _depthLength; _key ++ ) {
				this._folders[_folderDepth][_key]['sprite']._bodyReDraw();
			}
			// ЕСЛИ ЭТО ТЕКУЩИЙ УРОВЕНЬ НЕ НАИВЫСШИЙ, ПЕРЕРИСОВЫВАЕМ УРОВЕНЬ ВЫШЕ
			if ( _folderDepth > 0 ){
				this._levelReDraw(_folderDepth - 1);
			}
		}
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		//	ЗАКРЫВАЕМ ПАПКУ И ВСЕХ ДЕТЕЙ
		//
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _folderClose (_depthCurrent:uint,_positionCurrent:uint) {
			var _key:uint = new uint();
			if ( this._folders[_depthCurrent][_positionCurrent]['sprite']._selected ) {
				this._folders[_depthCurrent][_positionCurrent]['sprite']._head.getChildByName('Head')._iconChange(new FolderClosedSelected());
			}
			else {
				this._folders[_depthCurrent][_positionCurrent]['sprite']._head.getChildByName('Head')._iconChange(new FolderClosed());
			}
			this._folders[_depthCurrent][_positionCurrent]['sprite']._close();
			// ИЩЕМ ВЛОЖЕННЫЕ ПАПКИ
			if ( this._folders[_depthCurrent + 1] != null ) {
				var _numberOfChildNodes:uint = this._folders[_depthCurrent + 1].length;
			}
			for ( _key ; _key < _numberOfChildNodes ; _key ++ ) {
				if ( this._folders[_depthCurrent + 1][_key]['parentPosition'] == _positionCurrent ) {
					this._folderClose(_depthCurrent + 1,_key);
				}
			}
		}

		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//
		//	ФОРМИРУЕМ ПУТЬ К ТЕКУЩЕМУ КАТАЛОГУ
		//
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _pathMake ():Array {
			var _key:uint = new uint(0);
			var _pathTemp:String = new String();
			var _path:Array = new Array();
			// ПОЛНЫЙ ПУТЬ
			for ( _key; _key < this._depthCurrent + 1; _key ++ ){
				_pathTemp += this._pathCurrent[_key] + '/';
			}
			_path['full'] = _pathTemp;
			_pathTemp = new String();
			// ЧАСТИЧНЫЙ ПУТЬ
			for ( _key = 1; _key < this._depthCurrent + 1; _key ++ ){
				_pathTemp += this._pathCurrent[_key] + '/';
			}
			_path['short'] = _pathTemp;
			return _path;
		}

		
	}
}