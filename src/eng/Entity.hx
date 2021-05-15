package eng;

import dn.Cooldown;
import dn.Delayer;

class Entity {
    public static var ALL : Array<Entity> = [];
    public static var GC : Array<Entity> = [];

	public static function AllActive() {
		return ALL.filter(e -> return e.isAlive());
	}

	// Various getters to access all important stuff easily
	public var game(get,never) : Game; inline function get_game() return App.inst.game;
	public var fx(get,never) : Fx; inline function get_fx() return App.inst.fx;
	public var world(get,never) : World; inline function get_world() return App.inst.world;
	public var hud(get,never) : ui.Hud; inline function get_hud() return App.inst.hud;
	public var camera(get,never) : Camera; inline function get_camera() return App.inst.camera;
	public var input(get,never) : Input; inline function get_input() return App.inst.input;
	public var events(get,never) : EventRouter; inline function get_events() return App.inst.events;
	public var audio(get,never) : Audio; inline function get_audio() return App.inst.audio;
	
	public var destroyed(default,null) = false;
	public var ftime(get,never) : Float; inline function get_ftime() return game.ftime;
	public var tmod(get,never) : Float; inline function get_tmod() return game.tmod;

	/** Unique identifier **/
	public var uid(default,null) : Int;
	public var name : String;

	// Sprite transformations
	public var sprScaleX = 1.0;
	public var sprScaleY = 1.0;
	public var entityVisible = true;
	public var centerX = 0.0;
	public var centerY = 0.0;

    public var spr : HSprite;
	var debugLabel : Null<h2d.Text>;

    public function new(x, y) {
        uid = Const.NEXT_UNIQ;
		ALL.push(this);

		centerX = x;
		centerY = y;

		reset();
    }

	public inline function getDisplayName() {
		return name != null ? name : Type.getClassName(Type.getClass(this));
	}

	public function isAlive() {
		return !destroyed;
	}

	public function getCameraAnchorX() { return centerX; }
	public function getCameraAnchorY() { return centerY; }

	public function is<T:Entity>(c:Class<T>) return Std.isOfType(this, c);
	public function as<T:Entity>(c:Class<T>) : T return Std.downcast(this, c);

	public inline function rnd(min,max,?sign) return Lib.rnd(min,max,sign);
	public inline function irnd(min,max,?sign) return Lib.irnd(min,max,sign);
	public inline function pretty(v,?p=1) return M.pretty(v,p);

    public function destroy() {
        if(!destroyed) {
            destroyed = true;
            GC.push(this);
        }
    }

    public function dispose() {
        ALL.remove(this);

		if( debugLabel!=null ) {
			debugLabel.remove();
			debugLabel = null;
		}
    }

	public function reset() {}
    public function preUpdate() {}
    public function postUpdate() {}
	public function fixedUpdate() {}
    public function update() {}
}