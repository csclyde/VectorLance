class Entity {
    public static var ALL : Array<Entity> = [];
    public static var GC : Array<Entity> = [];

	// Various getters to access all important stuff easily
	public var game(get,never) : Game; inline function get_game() return Game.inst;
	public var fx(get,never) : Fx; inline function get_fx() return Game.inst.fx;
	public var level(get,never) : Level; inline function get_level() return Game.inst.level;
	public var destroyed(default,null) = false;
	public var ftime(get,never) : Float; inline function get_ftime() return game.ftime;
	public var tmod(get,never) : Float; inline function get_tmod() return Game.inst.tmod;
	public var hud(get,never) : ui.Hud; inline function get_hud() return Game.inst.hud;
	public var camera(get,never) : Camera; inline function get_camera() return Game.inst.camera;
	public var input(get,never) : Input; inline function get_input() return Game.inst.input;

	/** Unique identifier **/
	public var uid(default,null) : Int;

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
    }

	public inline function isAlive() {
		return !destroyed;
	}

	public function kill(by:Null<Entity>) {
		destroy();
	}

	public function is<T:Entity>(c:Class<T>) return Std.isOfType(this, c);
	public function as<T:Entity>(c:Class<T>) : T return Std.downcast(this, c);

	public inline function rnd(min,max,?sign) return Lib.rnd(min,max,sign);
	public inline function irnd(min,max,?sign) return Lib.irnd(min,max,sign);
	public inline function pretty(v,?p=1) return M.pretty(v,p);

    public inline function destroy() {
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

    public function preUpdate() {}
    public function postUpdate() {}
	public function fixedUpdate() {}
    public function update() {}
}