package eng;

class Camera extends Process {
	public var focus = {x: 0.0, y: 0.0};

	var target:Null<Entity>;

	public var pxWidth:Int;
	public var pxHeight:Int;

	var dx:Float;
	var dy:Float;

	public var clampToLevelBounds = false;

	public var left(get, never):Int;
	inline function get_left() return M.floor(focus.x - pxWidth * 0.5);

	public var right(get, never):Int;
	inline function get_right() return left + pxWidth - 1;

	public var top(get, never):Int;
	inline function get_top() return M.floor(focus.y - pxHeight * 0.5);

	public var bottom(get, never):Int;
	inline function get_bottom() return top + pxHeight - 1;

	public function new() {
		super(game);
		dx = dy = 0;
		// apply();

		pxWidth = M.ceil(game.w() / Const.SCALE);
		pxHeight = M.ceil(game.h() / Const.SCALE);
	}

	@:keep
	override function toString() {
		return 'Camera@${focus.x},${focus.y}';
	}

	override function reset() {
		recenter();
	}

	public function trackEntity(e:Entity, immediate:Bool = true) {
		target = e;
		if(immediate) recenter();
	}

	public inline function stopTracking() {
		target = null;
	}

	public inline function entityOnScreen(en:Entity, pad:Int) {
		return coordsOnScreen(en.centerX, en.centerY, pad);
	}

	public inline function coordsOnScreen(x:Float, y:Float, pad:Int) {
		if(x < left - pad || x > right + pad) {
			return false;
		}

		if(y < top - pad || y > bottom + pad) {
			return false;
		}

		return true;
	}

	public function recenter() {
		if(target != null) {
			focus.x = target.getCameraAnchorX();
			focus.y = target.getCameraAnchorY();
		}
	}

	public inline function levelToGlobalX(v:Float) return v * Const.SCALE + game.root.x;
	public inline function levelToGlobalY(v:Float) return v * Const.SCALE + game.root.y;

	var shakePower = 1.0;
	public function shakeS(t:Float, ?pow = 1.0) {
		cd.setS("shaking", t, false);
		shakePower = pow;
	}

	/** Apply camera values to Game root scene **/
	function apply() {
		var rootScene = world.root;

		rootScene.x = -focus.x + pxWidth * 0.5;
		rootScene.y = -focus.y + pxHeight * 0.5;

		// Shakes
		if(cd.has("shaking")) {
			rootScene.x += Math.cos(ftime * 1.1) * 2.5 * shakePower * cd.getRatio("shaking");
			rootScene.y += Math.sin(0.3 + ftime * 1.7) * 2.5 * shakePower * cd.getRatio("shaking");
		}

		// Scaling
		rootScene.x *= Const.SCALE;
		rootScene.y *= Const.SCALE;

		// Rounding
		rootScene.x = M.round(rootScene.x);
		rootScene.y = M.round(rootScene.y);
	}

	override function postUpdate() {
		super.postUpdate();
		apply();
	}

	override function update() {
		super.update();

		// Follow target entity
		if(target != null) {
			var s = 0.006;
			var deadZone = 1;
			var tx = target.getCameraAnchorX();
			var ty = target.getCameraAnchorY();

			var d = M.dist(focus.x, focus.y, tx, ty);
			if(d >= deadZone) {
				var a = Math.atan2(ty - focus.y, tx - focus.x);
				dx += Math.cos(a) * (d - deadZone) * s * tmod;
				dy += Math.sin(a) * (d - deadZone) * s * tmod;
			}
		}

		// Movements
		var frict = 0.89;
		focus.x += dx * tmod;
		dx *= Math.pow(frict, tmod);

		focus.y += dy * tmod;
		dy *= Math.pow(frict, tmod);
	}
}
