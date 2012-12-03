package engine {



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;



	// КЛАСС - ПОЦЕНЦИОМЕТР
	public class Potentiometer extends MovieClip {
		
		
		
		// СВОЙСТВА КЛАССА
			// ВНЕШНИЕ
			public var _eventDispatcher:EventDispatcher;				// ДИСПЕТЧЕР СОБЫТИЙ
			// ВНУТРЕННИЕ
			private var _mousePosPrev:Number;							// ПРЕДЫДУЩЕЕ ПОЛОЖЕНИЕ МЫШИ
			private var _valueCurrent:Number;							// ТЕКУЩЕЕ ЗНАЧЕНИЕ ПОТЕНЦИОМЕТРА
			private var _valueMin:Number;								// МИНИМАЛЬНОЕ ЗНАЧЕНИЕ
			private var _valueMax:Number;								// МАКСИМАЛЬНОЕ ЗНАЧЕНИ
			private var _speedMultyplier:Number;						// КОЭФФИЦИЕНТ СКОРОСТИ
		
		
		
		// КОНСТРУКТОР КЛАССА
		public function Potentiometer	(	_valueStart:Number,			// НАЧАЛЬНОЕ ПОЛОЖЕНИЕ ПОТЕНЦИОМЕТРА
										 	_valueMin:Number,			// МИНИМАЛЬНОЕ ЗНАЧЕНИЕ
											_valueMax:Number,			// МАКСИМАЛЬНОЕ ЗНАЧЕНИ
											_speedMultyplier:Number		// КОЭФФИЦИЕНТ СКОРОСТИ
										) {
			this.addEventListener(MouseEvent.MOUSE_DOWN,_spinStart);
			this._eventDispatcher = new EventDispatcher();
			this._regulator.rotation = _valueStart;
			this._valueMin = _valueMin;
			this._valueMax = _valueMax;
			this._speedMultyplier = _speedMultyplier;
		}
		
		
		
		// НАЧИНАЕМ КРУТИТЬ РУЧКУ
		private function _spinStart (_event:MouseEvent):void {
			this._mousePosPrev = this.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,_mouseUp);
		}
		
		
		
		// КРУТИМ РУЧКУ
		private function _mouseMove (_event:MouseEvent):void {
			this._regulator.rotation -= ( this.mouseY - this._mousePosPrev ) * this._speedMultyplier;
			this._mousePosPrev = this.mouseY;
			if ( this._regulator.rotation < 0 ) {
				this._valueCurrent = 360 + this._regulator.rotation;
			}
			else {
				this._valueCurrent = this._regulator.rotation;
			}
			this._eventDispatcher.dispatchEvent(new Event('VALUE_CHANGED'));
			this._positionCheck();
		}
		
		
		
		// ОТПУСТИЛИ РУЧКУ
		private function _mouseUp (_event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,_mouseUp);
		}
		
		
		
		// ПРОВЕРЯЕМ ДИАПАЗОН ИЗМЕНЕНИЯ
		private function _positionCheck ():void {
			if ( this._valueCurrent < this._valueMin ) {
				this._regulator.rotation = this._valueMin;
				//this._mouseUp(new MouseEvent(''));
			}
			else if ( this._valueCurrent > this._valueMax ) {
				this._regulator.rotation = this._valueMax;
				//this._mouseUp(new MouseEvent(''));
			}
		}
		
		
		
		// ВЫДАЕМ ТЕКУЩЕЕ ЗНАЧЕНИЕ
		public function get _value ():Number {
			return ( this._valueCurrent - this._valueMin ) / ( this._valueMax - this._valueMin );
		}
	}
}
