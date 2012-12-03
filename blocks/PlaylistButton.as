package blocks {
	
	import blocks.Block;
	import engine.Label;
	import flash.media.SoundChannel;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.display.DisplayObject;

	public class PlaylistButton extends Block {
		public var _trackNumber:uint;
		public function PlaylistButton	(	_width:Number,				// ШИРИНА
								 			_height:Number,				// ВЫСОТА
											_text:String,				// ТЕКСТ НАДПИСИ
											_textFormat:TextFormat,		// ФОРМАТ ТЕКСТА
											_folder:Boolean				// ЭТО - ПАПКА?
										):void {
			super(false);
			var _label:Label = new Label	(	_width - 20,
												_height,
												_text,
												_textFormat,
												false,
												false,
												0x000000,
												0,
												false,
												0x000000,
												0,
												0
											);
				_label.x = 20;
			this.addChild(_label);
			if ( ! _folder ){
				this.addEventListener(MouseEvent.CLICK,_eventClick);
				this._iconChange(new Track());
			}
			else {
				this._iconChange(new FolderClosed());
			}
		}
		private function _eventClick (_event:Event):void {
			this._trackPlay(this._trackNumber,0);
		}
		public function _iconChange (_icon:DisplayObject):void {
			if ( this.getChildByName('IconFolder') ) {
				this.removeChild(this.getChildByName('IconFolder'));
			}
			_icon.name = 'IconFolder';
			this.addChild(_icon);
		}
	}
}