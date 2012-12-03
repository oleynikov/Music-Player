package engine {
	// ИМПОРТ ПАКЕТОВ
	import engine.ScrollingText;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.Shape;
	import flash.display.Sprite;

	// КЛАСС - НАДПИСЬ
	public class Label extends Sprite {
		public function Label	(	_width:Number,				// ШИРИНА
								 	_height:Number,				// ВЫСОТА
									_text:String,				// ТЕКСТ НАДПИСИ
									_textFormat:TextFormat,		// ФОРМАТ ТЕКСТА
									_selectable:Boolean,		// НАДПИСЬ МОЖНО ВЫДЕЛИТЬ
									_background:Boolean,		// НАДПИСЬ С ФОНОМ
									_backgroundColor:uint,		// ЦВЕТ ФОНА
									_backgroundAlpha:Number,	// ПРОЗРАЧНОСТЬ ФОНА
									_border:Boolean,			// РАМКА
									_boderColor:uint,			// ЦВЕТ РАМКИ
									_borderSize:uint,			// ТОЛЩИНА РАМКИ
									_activationType:uint		// ТИП АКТИВАЦИИ ПРОКРУТКИ
								):void {
			if ( _background ) {
				var _backgroundShape:Shape = new Shape();
					_backgroundShape.graphics.beginFill(_backgroundColor,_backgroundAlpha);
					_backgroundShape.graphics.drawRect(0,0,_width,_height);
					_backgroundShape.graphics.endFill();
				this.addChild(_backgroundShape);
			}
			if ( _border ) {
				var _borderShape:Shape = new Shape();
					_borderShape.graphics.lineStyle(_borderSize,_boderColor);
					_borderShape.graphics.drawRect(0,0,_width,_height);
				this.addChild(_borderShape);				
			}
			var _label:ScrollingText = new ScrollingText	(	_width,
											 					_height,
																_textFormat,
																_activationType,
																1,
																500,
																_text
															);
			this.addChild(_label);
		}
		public function _moveTo	(	_x:uint,
								 	_y:uint
								):void {
			this.x = _x;
			this.y = _y;
		}
	}
}
