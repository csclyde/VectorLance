package eng;

typedef Callback = (Dynamic) -> Void;

class EventRouter {
	public var events:Map<String, Array<Callback>> = [];

	public function new() {}

	public function subscribe(eventName:String, newCallback:Callback) {
		var callbacks = events[eventName];

		if(callbacks == null) {
			events[eventName] = [];
			callbacks = events[eventName];
		}

		callbacks.push(newCallback);
	}

	public function send(eventName:String, ?params:Dynamic = null) {
		var callbacks = events[eventName];

		if(callbacks == null) {
			trace('Event (' + eventName + ') called with no listeners');
			return;
		}

		for(c in callbacks) {
			c(params);
		}
	}
}
