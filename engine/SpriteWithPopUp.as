package engine {



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Timer;



	// СПРАЙТ С ВСПЛЫВАЮЩЕЙ ПОДСКАЗКОЙ
	public class SpriteWithPopUp extends Sprite {
				
		
		
		// СВОЙСТВА КЛАССА
		private var _timer:Timer;				// ТАЙМЕР
		private var _popUp:Label;				// ВСПЛЫВАЮЩАЯ ПОДСКАЗКА
		private var _delay:uint;				// ЗАДЕРЖКА ПОЯВЛЕНИЯ ПОДСКАЗКИ
		private var _mouseIsOver:Boolean;		// МЫШЬ НАВЕДЕНА
				
		
		
		// КОНСТРУКТОР КЛАССА
		public function SpriteWithPopUp	(	_popUpMessage:String,
										 	_delay:uint
										) {			
			// ЗАДЕРЖКА ПОЯВЛЕНИЯ ПОДСКАЗКИ
			this._delay = _delay;
			// ДОБАВЛЯЕМ НАДПИСЬ
			this._popUp = new Label	(	100,
									 	20,
										_popUpMessage,
										new TextFormat(),
										false,
										true,
										0xFFFFFF,
										1,
										false,
										0x000000,
										0,
										3
									);
			this._popUp.visible = false;
			this.addChild(this._popUp);
			// ЖДЕМ НАВЕДЕНИЯ МЫШИ
			this.addEventListener(MouseEvent.ROLL_OVER,_mouseOver);
		}
		
		
		
		// НАВЕЛИ МЫШКУ
		private function _mouseOver (_event:MouseEvent):void {
			this._timerRefresh();
			this.addEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
			this.addEventListener(MouseEvent.ROLL_OUT,_mouseOut);
		}
		
		
		
		// ПАУЗА ВЫДЕРЖАНА
		private function _pauseComplete (_event:TimerEvent):void {
			this._popUp.y = this.mouseY - this._popUp.height;
			this._popUp.x = this.mouseX;
			this._popUp.visible = true;
		}
		
		
		
		// ДВИНУЛИ МЫШКОЙ
		private function _mouseMove (_event:MouseEvent):void {
			this._timerRefresh();
			this._popUp.visible = false;
		}
		
		
		
		// ПОКИНУЛИ ОБЪЕКТ
		private function _mouseOut (_event:MouseEvent):void {
			this._popUp.visible = false;
			this.removeEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
			this._timer.removeEventListener(TimerEvent.TIMER,_pauseComplete);
		}
		
		
		
		// ОБНОВЛЯЕМ ТАЙМЕР
		private function _timerRefresh ():void {
			if ( this._timer != null ) {
				this._timer.stop();
			}
			this._timer = new Timer(this._delay,1);
			this._timer.start();
			this._timer.addEventListener(TimerEvent.TIMER,_pauseComplete);
		}
	}
}
