package blocks{
	import engine.Potentiometer;
	import ControlButtonLoop;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;

	// КЛАСС - ПЛЕЙЛИСТ
	public class ControlPanel extends Block {
		
		private var _buttonPrev:ControlButtonPrev;		// НАЗАД
		private var _buttonStop:ControlButtonStop;		// СТОП
		private var _buttonPlay:ControlButtonPlay;		// ПЛЭЙ
		private var _buttonPause:ControlButtonPause;	// ПАУЗА
		private var _buttonNext:ControlButtonNext;		// ВПЕРЕД
		private var _buttonVolume:Potentiometer;		// ГРОМКОСТЬ
		private var _buttonLoop:ControlButtonLoop;		// ЗАЦИКЛИВАНИЕ
		
		// КОНСТРУКТОР КЛАССА
		public function ControlPanel() {
			super(true);
		}
		
		override protected function _configLoaded ():void {
			this._addBackground	(	this._configuration['width'],
									this._configuration['height'],
									this._configuration['bgColor'],
									this._configuration['bgAlpha']
								);			
			// КНОПКА НАЗАД
			this._buttonPrev = new ControlButtonPrev();
			this._buttonPrev.addEventListener(MouseEvent.CLICK,_clickPrev);
			this._buttonPrev.addEventListener(MouseEvent.MOUSE_DOWN,_pushPrev);
			this._buttonPrev.addEventListener(MouseEvent.MOUSE_UP,_pullPrev);
			this._buttonPrev.x = 5;
			this._buttonPrev.y = 5;
			// КНОПКА СТОП
			this._buttonStop = new ControlButtonStop();
			this._buttonStop.addEventListener(MouseEvent.CLICK,_clickStop);
			this._buttonStop.x = 30;
			this._buttonStop.y = 5;
			// КНОПКА ПЛЭЙ
			this._buttonPlay = new ControlButtonPlay();
			this._buttonPlay.addEventListener(MouseEvent.CLICK,_clickPlay);
			this._buttonPlay.x = 55;
			this._buttonPlay.y = 5;
			Block._eventDispatcher.addEventListener('TRACK_STARTED',_pushPlay);
			// КНОПКА ПАУЗА
			this._buttonPause = new ControlButtonPause();
			this._buttonPause.addEventListener(MouseEvent.CLICK,_clickPause);
			this._buttonPause.x = 80;
			this._buttonPause.y = 5;
			// КНОПКА ВПЕРЕД
			this._buttonNext = new ControlButtonNext();
			this._buttonNext.addEventListener(MouseEvent.CLICK,_clickNext);
			this._buttonNext.addEventListener(MouseEvent.MOUSE_DOWN,_pushNext);
			this._buttonNext.addEventListener(MouseEvent.MOUSE_UP,_pullNext);
			this._buttonNext.x = 105;
			this._buttonNext.y = 5;
			// ГРОМКОСТЬ
			this._buttonVolume = new Potentiometer(180,45,315,1);
			this._buttonVolume._eventDispatcher.addEventListener('VALUE_CHANGED',_clickVolume);
			this._buttonVolume.addEventListener(MouseEvent.MOUSE_DOWN,_pushVolume);
			stage.addEventListener(MouseEvent.MOUSE_UP,_pullVolume);
			this._buttonVolume.x = 130;
			this._buttonVolume.y = 5;
			// ЦИКЛ
			this._buttonLoop = new ControlButtonLoop();
			this._buttonLoop.addEventListener(MouseEvent.CLICK,_clickLoop);
			this._buttonLoop.x = 155;
			this._buttonLoop.y = 5;
			// ДОБАВЛЯЕМ КНОПКИ
			this.addChild(this._buttonPrev);
			this.addChild(this._buttonStop);
			this.addChild(this._buttonPlay);
			this.addChild(this._buttonPause);
			this.addChild(this._buttonNext);
			this.addChild(this._buttonVolume);
			this.addChild(this._buttonLoop);
		}
		// НАЗАД
		private function _pushPrev(_event:MouseEvent):void {
			this._buttonPrev._background.gotoAndStop(2);
		}
		private function _pullPrev(_event:MouseEvent):void {
			this._buttonPrev._background.gotoAndStop(1);
		}
		private function _clickPrev(_event:MouseEvent):void {
			if (Block._trackCurrent > 0) {
				this._trackPlay(Block._trackCurrent - 1 , 0);
			}
			else {
				this._trackPlay(Block._trackCurrent , 0);
			}
		}
		// СТОП
		private function _clickStop(_event:MouseEvent):void {
			this._trackStop();
			this._buttonStop._background.gotoAndStop(2);
			this._buttonPause._background.gotoAndStop(1);
			this._buttonPlay._background.gotoAndStop(1);
		}
		// ПЛЭЙ
		private function _clickPlay(_event:Event):void {
			if ( Block._trackIsPaused ) {
				this._trackPlay(Block._trackCurrent , Block._trackPositionCurrent);
			}
			else {
				this._trackPlay(Block._trackCurrent , 0);
			}
			this._buttonPlay._background.gotoAndStop(2);
			this._buttonStop._background.gotoAndStop(1);
			this._buttonPause._background.gotoAndStop(1);
		}
		private function _pushPlay (_event:Event):void {
			this._buttonPlay._background.gotoAndStop(2);
			this._buttonStop._background.gotoAndStop(1);
			this._buttonPause._background.gotoAndStop(1);
		}
		// ПАУЗА
		private function _clickPause(_event:MouseEvent):void {
			if ( Block._trackIsPlaying ) {
				Block._trackPositionCurrent = Block._soundChannel.position;
				this._trackStop();
				Block._trackIsPaused = true;
				this._buttonPause._background.gotoAndStop(2);
				this._buttonPlay._background.gotoAndStop(1);
			}
			else if ( Block._trackIsPaused ) {
				this._trackPlay(Block._trackCurrent,Block._trackPositionCurrent);
				this._buttonPause._background.gotoAndStop(1);
				this._buttonPlay._background.gotoAndStop(2);
			}
		}
		// ВПЕРЕД
		private function _pushNext(_event:MouseEvent):void {
			this._buttonNext._background.gotoAndStop(2);
		}
		private function _pullNext(_event:MouseEvent):void {
			this._buttonNext._background.gotoAndStop(1);
		}
		private function _clickNext(_event:MouseEvent):void {
			if (Block._trackCurrent < Block._tracks.length - 1) {
				this._trackPlay(Block._trackCurrent + 1 , 0);
			}
			else {
				this._trackPlay(Block._trackCurrent , 0);
			}
		}
		// ГРОМКОСТЬ
		private function _pushVolume(_event:MouseEvent):void {
			this._buttonVolume._background.gotoAndStop(2);
		}
		private function _pullVolume(_event:MouseEvent):void {
			this._buttonVolume._background.gotoAndStop(1);
		}
		private function _clickVolume(_event:Event):void {
			Block._soundTransform = new SoundTransform ( this._buttonVolume._value , 0);
			Block._soundChannel.soundTransform = Block._soundTransform;
		}
		// ЦИКЛ
		private function _clickLoop(_event:MouseEvent):void {
			if ( Block._loopEnabled ) {
				this._buttonLoop._background.gotoAndStop(1);
				Block._loopEnabled = false;
			}
			else {
				this._buttonLoop._background.gotoAndStop(2);
				Block._loopEnabled = true;
			}
		}
	}
}