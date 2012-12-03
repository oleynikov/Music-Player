package engine {
	
	
	
	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.events.Event;
	
	
	// КОНТЕЙНЕР С ПОЛОСОЙ ПРОКРУТКИ
	public class ScrollingContainer extends Sprite {
		
		
		
		// СВОЙСТВА КЛАССА
		private var _width:Number;				// ШИРИНА КОНТЕЙНЕРА
		private var _height:Number;				// ВЫСОТА КОНТЕЙНЕРА
		private var _child:Sprite;				// СОДЕРЖИМОЕ КОНТЕЙНЕРА
		private var _scrollBar:Sprite;			// ПОЛОСА ПРОКРУТКИ
		private var _scrollMaxY:Number;			// МАКСИМАЛЬНЫЙ У ПОЛОСЫ ПРОКРУТКИ
		private var _heightDelta:Number;		// РАЗНИЦА ВЫСОТ КОНТЕЙНЕРА И СОДЕРЖИМОГО
		private const _paddingTop:Number = 5;	// ОТСТУП СВЕРХУ
		private const _paddingLeft:Number = 5;	// ОТСТУП СЛЕВА
		
		
		
		// КОНСТРУКТОР КЛАССА
		public function ScrollingContainer	(	_width:Number,		// ШИРИНА КОНТЕЙНЕРА
											 	_height:Number,		// ВЫСОТА КОНТЕЙНЕРА
												_color:uint,		// ЦВЕТ ФОНА
												_alpha:Number,		// ПРОЗРАЧНОСТЬ
												_child:Sprite		// СОДЕРЖИМОЕ КОНТЕЙНЕРА
											) {
			// ЗАПИСЫВАЕМ РАЗМЕРЫ КОНТЕЙНЕРА
			this._width = _width;
			this._height = _height;
			// РИСУЕМ ФОН
			var _background:Shape = new Shape();
				_background.graphics.beginFill(_color,_alpha);
				_background.graphics.drawRect(0,0,_width,_height);
				_background.graphics.endFill();
			this.addChild(_background);
			// ДОБАВЛЯЕМ ПОЛЗУНОК
			this._scrollBar = new Sprite();
			this._scrollBar.x = this._width - 5;
			this._scrollBar.addEventListener(MouseEvent.MOUSE_DOWN,_scrollBarDrag);
			this.addChild(this._scrollBar);
			var _newScrollBar:Shape = new Shape();
				_newScrollBar.graphics.beginFill(0x000000,0.3);
				_newScrollBar.graphics.drawRoundRect(0,0,5,this._height,0,0);
				_newScrollBar.graphics.endFill();
				_newScrollBar.name = 'NewScrollBar';
			this._scrollBar.addChild(_newScrollBar);
			// ДОБАВЛЯЕМ РЕБЕНКА
			this._child = _child;
			this._child.x = this._paddingLeft;
			this._child.y = this._paddingTop;
			this.addChild(_child);
			// РИСУЕМ МАСКУ
			var _mask:Shape = new Shape();
				_mask.graphics.beginFill(0x000000,1);
				_mask.graphics.drawRect	(	this._paddingLeft,
										 	this._paddingTop,
											_width - this._paddingLeft * 2,
											_height - this._paddingTop * 2
										);
				_mask.graphics.endFill();
			this.addChild(_mask);
			this._child.mask = _mask;
			// ПРОВЕРЯЕМ, ПОМЕСТИЛСЯ ЛИ РЕБЕНОК
			this._contentUpdate();
		}
		
		
		
		// ПРОВЕРКА РАЗМЕРОВ РЕБЕНКА
		public function _contentUpdate ():void {
			// РАЗНИЦА ВЫСОТ КОНТЕЙНЕРА И СОДЕРЖИМОГО
			this._heightDelta = this._height - this._child.height - this._paddingTop * 2;
			// ЕСЛИ СОДЕРЖИМОЕ ПРОКРУЧЕНО СЛИШКОМ СИЛЬНО
			if ( this._child.y < this._heightDelta + this._paddingTop ) {
				this._child.y = this._heightDelta + this._paddingTop;
			}
			// ЕСЛИ СОДЕРЖИМОЕ НЕ ПОМЕЩАЕТСЯ
			if ( this._heightDelta < 0 ) {
				this.addEventListener(MouseEvent.MOUSE_WHEEL,_scrollWheelSpin);
			}
			// ЕСЛИ СОДЕРЖИМОЕ ПОМЕЩАЕТСЯ
			else{
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,_scrollWheelSpin);
				this._child.y = this._paddingTop;
			}
			this._scrollBarUpdate();
		}
		
		

		// НАСТРАИВАЕМ ПОЛЗУНОК
		public function _scrollBarUpdate ():void {
			// ЕСЛИ СОДЕРЖИМОЕ БОЛЬШЕ КОНТЕЙНЕРА
			this._heightDelta = this._height - this._child.height - this._paddingTop * 2;
			// КАКОЙ ПРОЦЕНТ СОДЕРЖИМОГО ПРОКРУЧЕН
			var _scrollPercent:Number = ( this._child.y - this._paddingTop ) / this._heightDelta;
			// КАКОЙ ПРОЦЕНТ СОДЕРЖИМОГО ВИДЕН НА ЭКРАНЕ
			var _percentVisible:Number = this._height / this._child.height;
			// ИЗМЕНЯЕМ РАЗМЕР СКРОЛЛБАРА
			if ( this._heightDelta < 0 ) {
				this._scrollBar.height = ( this._height - this._paddingTop * 2 ) * _percentVisible;
			}
			else {
				this._scrollBar.height = this._height;
			}
			// НАИБОЛЬШАЯ КООРДИНАТА Y СКРОЛЛБАРА
			this._scrollMaxY = this._height - this._scrollBar.height;
			this._scrollBar.y = _scrollPercent * this._scrollMaxY;
		}
		
		
		
		// ТАЩИМ СКРОЛЛБАР
		private function _scrollBarDrag (_event:MouseEvent):void {
			this._scrollBar.startDrag	(	false,
										 	new Rectangle	(	this._width - 5,
															 	0,
																0,
																this._height - this._scrollBar.height
															)
										);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,_childMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,_scrollBarDrop);
		}
		
		
		
		// ОТПУСКАЕМ СКРОЛЛБАР
		private function _scrollBarDrop (_event:MouseEvent):void {
			this._scrollBar.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,_childMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,_scrollBarDrop);
		}
		
		
		
		// ДВИГАЕМ СОДЕРЖИМОЕ
		private function _childMove (_event:MouseEvent):void {
			var _scrollBarPositionPercent:Number;
			if ( this._heightDelta < 0 ) {
				_scrollBarPositionPercent = this._scrollBar.y / this._scrollMaxY;
			}
			else {
				_scrollBarPositionPercent = 0;
			}
			this._child.y = this._heightDelta * _scrollBarPositionPercent + this._paddingTop;
		}
		
		
		
		// ГРАНИЦЫ
		private function _positionCheck (_event:Event):void {
			if ( this._child.y > this._paddingTop ){
				this._child.y = this._paddingTop;
			}
			else if ( this._child.y < this._height - this._child.height - this._paddingTop){
				this._child.y = this._height - this._child.height - this._paddingTop;
			}
		}
		
		
		
		// КРУТИМ КОЛЕСО
		private function _scrollWheelSpin (_event:MouseEvent):void {
			this._child.y += _event.delta * 10;
			this._positionCheck(new Event(''));
			this._scrollBarUpdate();
		}
	}
}
