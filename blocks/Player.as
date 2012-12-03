package blocks{



	// ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ
	import blocks.ControlPanel;
	import blocks.StatusBar;
	import blocks.Playlist;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;



	// КЛАСС - ПЛЕЕР
	public class Player extends Block {




		// КОНСТРУКТОР КЛАССА
		public function Player() {
			super(false);
		}



		// КОНФИГ ЗАГРУЖЕН
		override protected function _configLoaded():void {
			// ПРЯЧЕМ КОНТЕКСТНОЕ МЕНЮ
			var _ContextMenu:ContextMenu = new ContextMenu();
			_ContextMenu.hideBuiltInItems();
			this.contextMenu = _ContextMenu;
			// NOSCALE
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// ПЛЕЙЛИСТ
			var _playlist:Playlist = new Playlist();
			this.addChild(_playlist);
			// ПАНЕЛЬ УПРАВЛЕНИЯ
			var _controlPanel:ControlPanel = new ControlPanel();
			_controlPanel.y = 415;
			this.addChild(_controlPanel);
			// СТАТУС БАР
			var _statusBar:StatusBar = new StatusBar();
			_statusBar.y = 400;
			this.addChild(_statusBar);
		}
	}
}