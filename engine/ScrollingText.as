package engine{
	// ИМПОРТИРУЕМЫЕ ПАКЕТЫ
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class ScrollingText extends Sprite {
		// СВОЙСТВА КЛАССА
		private var st_TextField:TextField;
		private var st_TextFieldWidth:Number;
		private var st_TextFieldHeight:Number;
		private var st_TextWidthDifference:Number;
		private var st_ScrollSpeed:Number;
		private var st_ActivationType:uint;
		private var st_IsScrolling:Boolean;
		private var st_PauseDuration:Number;
		// КОНСТРУКТОР КЛАССА
		public function ScrollingText	(	st_Width:Number,			// ШИРИНА ТЕКСТОВОГО ПОЛЯ
											st_Height:Number,			// ВЫСОТА ТЕКСТОВОГО ПОЛЯ
											st_TextFormat:TextFormat,	// ФОРМАТ ТЕКСТА
											st_ActivationType:uint,		// СПОСОБ АКТИВАЦИИ ПРОКРУТКИ
											st_ScrollSpeed:Number,		// СКОРОСТЬ ПРОКРУТКИ
											st_PauseDuration:Number,	// ВРЕМЯ ПАУЗЫ	
											st_Message:String			// ТЕКСТ
										) {
			// ИНИЦИАЛИЗИРУЕМ ПЕРЕМЕННЫЕ
			this.st_ActivationType = st_ActivationType;
			this.st_ScrollSpeed = st_ScrollSpeed;
			this.st_TextFieldWidth = st_Width;
			this.st_TextFieldHeight = st_Height;
			this.st_PauseDuration = st_PauseDuration;
			// НАСТРАИВАЕМ ТЕКСТОВОЕ ПОЛЕ
			this.st_TextField = new TextField();
			this.st_TextField.selectable = false;
			this.st_TextField.autoSize = TextFieldAutoSize.LEFT;
			this.st_TextField.defaultTextFormat = st_TextFormat;
			this.st_TextChange(st_Message);
			this.addChild(this.st_TextField);
			// ДОБАВЛЯЕМ МАСКУ
			var	st_Mask:Shape = new Shape();
			st_Mask.graphics.beginFill(0x000000,1);
			st_Mask.graphics.drawRect(0,0,st_Width,st_Height);
			st_Mask.graphics.endFill();
			this.addChild(st_Mask);
			this.mask = st_Mask;
		}
		// ФУНКЦИЯ ОБНОВЛЕНИЯ ТЕКСТА
		public function st_TextChange(st_Message:String) {
			this.st_TextField.text = st_Message;
			this.st_TextWidthDifference = this.st_TextFieldWidth - this.st_TextField.textWidth - 3;
			// ЕСЛИ ТЕКСТ НЕ ПОМЕЩАЕТСЯ В ЗАДАННУЮ ДЛИНУ
			if ( this.st_TextWidthDifference < 0 ) {
				switch ( this.st_ActivationType ) {
					case 1:
						this.addEventListener(MouseEvent.ROLL_OVER,st_ScrollBegin);
						break;
					case 2:
						this.addEventListener(MouseEvent.CLICK,st_ScrollBegin);
						break;
					case 3:
						this.st_IsScrolling = true;
						this.addEventListener(Event.ENTER_FRAME,st_TextMove);
						break;
				}
			}
		}
		// ФУНКЦИЯ НАЧАЛА ПРОКРУТКИ ТЕКСТА
		private function st_ScrollBegin(st_Event:Event) {
			this.st_IsScrolling = true;
			this.addEventListener(Event.ENTER_FRAME,st_TextMove);
			switch ( this.st_ActivationType ) {
				case 1:
					this.removeEventListener(MouseEvent.ROLL_OVER,st_ScrollBegin);
					this.addEventListener(MouseEvent.ROLL_OUT,st_ScrollStop);
					break;
				case 2:
					this.removeEventListener(MouseEvent.CLICK,st_ScrollBegin);
					this.addEventListener(MouseEvent.CLICK,st_ScrollStop);
					break;
			}
		}
		// ФУНКЦИЯ ОКОНЧАНИЯ ПРОКРУТКИ ТЕКСТА
		private function st_ScrollStop(st_Event:Event) {
			this.st_IsScrolling = false;
			switch ( this.st_ActivationType ) {
				case 1:
					this.removeEventListener(MouseEvent.ROLL_OUT,st_ScrollStop);
					this.addEventListener(MouseEvent.ROLL_OVER,st_ScrollBegin);
					break;
				case 2:
					this.removeEventListener(MouseEvent.CLICK,st_ScrollStop);
					this.addEventListener(MouseEvent.CLICK,st_ScrollBegin);
					break;
			}
		}
		// ФУНКЦИЯ ПРОКРУТКИ ТЕКСТА
		private function st_TextMove(st_Event:Event) {
			this.st_TextField.x -=  this.st_ScrollSpeed;
			var _timer:Timer = new Timer(this.st_PauseDuration,1);
			
			if ( this.st_TextField.x <= this.st_TextWidthDifference || this.st_TextField.x >= 0 ) {
				this.removeEventListener(Event.ENTER_FRAME,st_TextMove);
				this.removeEventListener(MouseEvent.ROLL_OVER,st_ScrollBegin);
				_timer.addEventListener(TimerEvent.TIMER,_pauseComplete);
				_timer.start();
			}
			if (! this.st_IsScrolling && this.st_TextField.x >= 0 ) {
				_timer.removeEventListener(TimerEvent.TIMER,_pauseComplete);
				this.removeEventListener(Event.ENTER_FRAME,st_TextMove);
				this.addEventListener(MouseEvent.ROLL_OVER,st_ScrollBegin);
				this.st_ScrollSpeed *= -1;
			}
		}
		private function _pauseComplete (_event:TimerEvent):void {
			this.addEventListener(Event.ENTER_FRAME,st_TextMove);
			this.st_ScrollSpeed *= -1;
		}
	}
}