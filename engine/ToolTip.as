package engine {
	// ИМПОРТ ПАКЕТОВ
	import engine.Label;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	// КЛАСС - ВСПЛЫВАЮЩАЯ ПОДСКАЗКА
	public class ToolTip extends MovieClip {
		// СВОЙСТВА КЛАССА
		private var _toolTip:Label;
		private var _textFormat:TextFormat;
		private var _timer:Timer;
		private var _mouseOver:Boolean;
		private var _tipShown:Boolean;

		// КОНСТРУКТОР
		public function ToolTip(_tip:String):void {
			
			this._textFormat = new TextFormat('Tahoma',10);
			
			this._toolTip = new Label	(	200,				// ШИРИИНА
											20,					// ВЫСОТА
											_tip,				// ТЕКСТ
											this._textFormat,	// ФОРМАТ ТЕКСТА
											false,				// МОЖНО ВЫДЕЛИТЬ
											false,				// ФОН НАДПИСИ
											0x000000,			// ЦВЕТ ФОНА
											0,					// ПРОЗРАЧНОСТЬ ФОНА
											false,				// РАМКА
											0x000000,			// ЦВЕТ РАМКИ
											0,					// ТОЛЩИНА РАМКИ
											0					// АКТИВАЦИЯ ПРОКРУТКИ: АВТОМАТИЧЕСКАЯ
										);
			this._toolTip.visible = false;
			this.addChild(this._toolTip);
			
			
			this.addEventListener(MouseEvent.ROLL_OVER,_rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,_rollOut);
			this.addEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
		}
		
		// НАВЕЛИ МЫШКУ
		private function _rollOver (_event:MouseEvent):void {
			//trace('Roll Over');
			this._mouseOver = true;
		}

		// УБРАЛИ МЫШКУ
		private function _rollOut (_event:MouseEvent):void {
			//trace('Roll Out');
			this._mouseOver = false;
			if ( this._timer != null ) {
				this._timer.stop();
			}
		}
		
		// ДВИНУЛИ МЫШКУ
		private function _mouseMove (_event:MouseEvent):void {
			//trace('Mouse Move');
			if ( ! this._tipShown ) {
				_timerStart();
			}
			else {
				this._tipHide();
			}
		}
		
		// ЗАПУСТИТЬ ТАЙМЕР
		private function _timerStart ():void {
			//trace('timer Start');
			if ( this._timer != null ) {
				this._timer.stop();
			}
			this._timer = new Timer(1000,0);
			this._timer.start();
			this._timer.addEventListener(TimerEvent.TIMER, _tipShow);
		}
		
		// ПОКАЗАТЬ ПОДСКАЗКУ
		private function _tipShow (_event:TimerEvent):void {
			this._toolTip.visible = true;
			this._tipShown = true;
		}
				
		// СКРЫТЬ СКАЗКУ
		private function _tipHide ():void {
			this._toolTip.visible = false;
			this._tipShown = false;
		}
	}
}