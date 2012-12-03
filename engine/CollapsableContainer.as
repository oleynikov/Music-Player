package engine {
	// ИМПОРТ ПАКЕТОВ
	import engine.ContainerEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.DisplayObject;
	// КЛАСС - СВОРАЧИВАЕМЫЙ СПИСОК
	public class CollapsableContainer extends Sprite{
		public var _opened:Boolean;
		private var _body:Sprite;
		public var _head:Sprite;
		private var _bodyArray:Array;
		private var _headArray:Array;
		public var _depth:uint;
		public var _position:uint;
		public var _selected:Boolean;
		public var _eventDispatcher:EventDispatcher;
		// КОНСТРУКТОР
		public function CollapsableContainer(_opened:Boolean):void {
			this._eventDispatcher = new EventDispatcher();
			// ШАПКА ОКНА
			this._head = new Sprite();
			this._head.name = '_head';
			this.addChild(this._head);
			this._head.addEventListener(MouseEvent.CLICK,_stateChange);
			// ТЕЛО ОКНА
			this._bodyArray = new Array();
			this._body = new Sprite();
			this._body.name = '_body';
			this._opened = _opened;
			if ( _opened ) {
				this.addChild(this._body);
			}
		}
		// ИЗМЕНЕНИЕ СОСТОЯНИЯ ОКНА
		private function _stateChange (_event:MouseEvent):void {
			var _eventParameters = new Array();
				_eventParameters.push ( this._depth );
				_eventParameters.push ( this._position );

			if ( this._opened ) {
				this.removeChild(this.getChildByName('_body'));
				_eventParameters.push ( 'CONTAINER_CLOSED' );
				this._opened = false;
			}
			else{
				this.addChild(this._body);
				_eventParameters.push ( 'CONTAINER_OPENED' );
				this._opened = true;
			}
				
			this._eventDispatcher.dispatchEvent(new ContainerEvent('STATE_CHANGED',_eventParameters));
		}
		// ДОБАВЛЯЕМ ГОЛОВУ
		public function _headAdd (_element:Sprite):void {
			_element.name = 'Head';
			this._head.addChild(_element);
		}
		// ДОБАВЛЯЕМ ЭЛЕМЕНТ В ТЕЛО
		public function _bodyAdd (_element:DisplayObject):void {
			var _headHeight:Number = this._head.height;
			var _bodyHeight:Number = this._body.height;
			this._body.y = _headHeight;
			_element.y = _bodyHeight;
			this._bodyArray.push(_element);
			this._body.addChild(_element);
		}
		// ОБНОВЛЯЕМ РАЗМЕРЫ ТЕЛА
		public function _bodyReDraw ():void {
			var _key:uint = new uint();
			var _bodyLength:uint = this._body.numChildren;
			for ( _key; _key < _bodyLength; _key ++ ){
				this._body.removeChildAt(0);
			}
			for ( _key = 0; _key < _bodyLength; _key ++ ){
				var _bodyHeight:Number = this._body.height;
				var _element:DisplayObject = this._bodyArray[_key];
					_element.y = _bodyHeight;
				this._body.addChild(_element);
			}
		}
		// ИЗМЕНЕНИЕ СОСТОЯНИЯ ОКНА
		public function _close ():void {
			if ( this._opened ) {
				this.removeChild(this.getChildByName('_body'));
				this._opened = false;
			}
		}
	}
}