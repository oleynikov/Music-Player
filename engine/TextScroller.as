package engine{



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import flash.text.TextFieldAutoSize;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Timer;
	
	
	
	// КЛАСС - ПРОКРУТЧИК ТЕКСТА
	public class TextScroller extends Sprite {
		
		
		
		// СВОЙСТВА КЛАССА
		private var _TextField:TextField;
		private var _TextFieldWidth:Number;
		private var _TextFieldHeight:Number;
		private var _WidthDifference:Number;
		private var _ScrollSpeed:Number;
		private var _ActivationType:String;
		private var _IsScrolling:Boolean;
		private var _PauseDuration:Number;
		private var _PauseTimer:Timer;
		private var _Tween:Tween;
		
		
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		КОНСТРУКТОР
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function TextScroller	(	_Width:Number,											// ШИРИНА ТЕКСТОВОГО ПОЛЯ
											_Height:Number,											// ВЫСОТА ТЕКСТОВОГО ПОЛЯ
											_Message:String,											// ТЕКСТ
											_TextFormat:TextFormat,
											_ActivationType:String = 'AUTO',									// СПОСОБ АКТИВАЦИИ ПРОКРУТКИ
											_ScrollSpeed:Number = 1,									// СКОРОСТЬ ПРОКРУТКИ
											_PauseDuration:Number = 500								// ВРЕМЯ ПАУЗЫ	
										) {
			// ИНИЦИАЛИЗИРУЕМ ПЕРЕМЕННЫЕ
			this._ActivationType = _ActivationType;
			this._ScrollSpeed = _ScrollSpeed;
			this._TextFieldWidth = _Width;
			this._TextFieldHeight = _Height;
			this._PauseDuration = _PauseDuration;
			// НАСТРАИВАЕМ ТЕКСТОВОЕ ПОЛЕ
			this._TextField = new TextField();
			this._TextField.selectable = false;
			this._TextField.autoSize = TextFieldAutoSize.LEFT;
			this._TextField.defaultTextFormat = _TextFormat;
			this._TextChange(_Message);
			this.addChild(this._TextField);
			// ДОБАВЛЯЕМ МАСКУ
			var	_Mask:Shape = new Shape();
			_Mask.graphics.beginFill(0x000000,1);
			_Mask.graphics.drawRect(0,0,_Width,_Height);
			_Mask.graphics.endFill();
			this.addChild(_Mask);
			this.mask = _Mask;
		}
		
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		ОБНОВИТЬ ТЕКСТ
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _TextChange(_Message:String):void {
			this._TextField.text = _Message;
			this._WidthDifference = this._TextFieldWidth - this._TextField.textWidth;
			// ЕСЛИ ТЕКСТ НЕ ПОМЕЩАЕТСЯ В ЗАДАННУЮ ДЛИНУ
			if ( this._WidthDifference < 0 ) {
				switch ( this._ActivationType ) {
					// ПРОКРУТКА ПО ЩЕЛЧКУ
					case 'CLICK':
						this.addEventListener(MouseEvent.CLICK,_ScrollBegin);
						break;
					// ПРОКРУТКА СТАРТУЕТ АВТОМАТИЧЕСКИ И НЕ ОСТАНАВЛИВАЕТСЯ
					case 'AUTO':
						this._IsScrolling = true;
						this._TextScroll();
						break;
				}
			}
		}
		
		
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		ПРОИЗОШЛА АКТИВАЦИЯ ПРОКРУТКИ
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _ScrollBegin(_Event:Event) {
		}		
		
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		ПРОИЗОШЛА ДЕ-АКТИВАЦИЯ ПРОКРУТКИ
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _ScrollEnd(_Event:Event) {
		}
		
		
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		МЕХАНИЗМ ПРОКРУТКИ ТЕКСТА
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _TextScroll():void {
			var _destination:Number;
			
			if ( this._TextField.x < 0 ) {
				_destination = 0;
			}
			else {
				_destination = this._WidthDifference;
			}
			trace(_destination)
			this._Tween = new Tween(this,'x',None.easeNone,this._TextField.x,_destination,this._ScrollSpeed,true);
			this._Tween.start();
			this._Tween.addEventListener(TweenEvent.MOTION_FINISH,_TextScrollReverse);
		}
		
		function _TextScrollReverse (_event:TweenEvent):void {
			this._Tween.yoyo();
		}

		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//		ПАУЗА В КРАЙНИХ ПОЛОЖЕНИЯХ ВЫДЕРЖАНА
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		private function _pauseComplete (_event:TimerEvent):void {
		}
	}
}