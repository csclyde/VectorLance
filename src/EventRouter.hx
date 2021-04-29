typedef Callback = (Dynamic) -> Void;

class EventRouter {

    public var events: Map<String, Array<Callback>> = [];

    public function new() {
        
    }

    public function subscribe(eventName: String, newCallback: Callback) {
        var callbacks = events[eventName];

        if(callbacks == null) {
            events[eventName] = [];
            callbacks = events[eventName];
        }

        callbacks.push(newCallback);
        trace("Added callback " + eventName);
    }

    public function send(eventName: String, params: Dynamic) {
        var callbacks = events[eventName];

        for(c in callbacks) {
            c(params);
        }
    }
}