package engine {
	import flash.events.Event;
	public class ContainerEvent extends Event {
		public var _parameters:*;
		public function ContainerEvent	(	_type:String,
										 	_parameters:*
										) {
			this._parameters = _parameters;
			super(_type);
		}
	}
}