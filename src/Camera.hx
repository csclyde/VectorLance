class Camera extends dn.Process {
	public var focus = { x: 0.0, y: 0.0 };

	var target : Null<Entity>;

    public var pxWidth(get,never) : Int;
	public var pxHeight(get,never) : Int;

	var dx : Float;
	var dy : Float;
	var bumpOffX = 0.;
	var bumpOffY = 0.;

	public var clampToLevelBounds = false;

	/** Left camera bound in level pixels **/
	public var left(get,never) : Int;
		inline function get_left() return M.imax( M.floor( focus.x-pxWidth*0.5 ), clampToLevelBounds ? 0 : -Const.INFINITE );

	/** Right camera bound in level pixels **/
	public var right(get,never) : Int;
		inline function get_right() return left + pxWidth - 1;

	/** Upper camera bound in level pixels **/
	public var top(get,never) : Int;
		inline function get_top() return M.imax( M.floor( focus.y-pxHeight*0.5 ), clampToLevelBounds ? 0 : -Const.INFINITE );

	/** Lower camera bound in level pixels **/
	public var bottom(get,never) : Int;
		inline function get_bottom() return top + pxHeight - 1;


	public function new() {
		super(Game.ME);
		dx = dy = 0;
		apply();
	}

	@:keep
	override function toString() {
		return 'Camera@${focus.x},${focus.y}';
	}

	function get_pxWidth() {
		return M.ceil( Game.ME.w() / Const.SCALE );
	}

	function get_pxHeight() {
		return M.ceil( Game.ME.h() / Const.SCALE );
	}

	public function trackEntity(e:Entity, immediate:Bool) {
		target = e;
		if(immediate )
			recenter();
	}

	public inline function stopTracking() {
		target = null;
	}

	public function recenter() {
		if(target!=null ) {
			focus.x = target.centerX;
			focus.y = target.centerY;
		}
	}

	public inline function levelToGlobalX(v:Float) return v*Const.SCALE + Game.ME.view_layers.x;
	public inline function levelToGlobalY(v:Float) return v*Const.SCALE + Game.ME.view_layers.y;

	var shakePower = 1.0;
	public function shakeS(t:Float, ?pow=1.0) {
		cd.setS("shaking", t, false);
		shakePower = pow;
	}

	public inline function bumpAng(a, dist) {
		bumpOffX+=Math.cos(a)*dist;
		bumpOffY+=Math.sin(a)*dist;
	}

	public inline function bump(x,y) {
		bumpOffX+=x;
		bumpOffY+=y;
	}


	/** Apply camera values to Game view_layers **/
	function apply() {
		var level = Game.ME.level;
		var view_layers = Game.ME.view_layers;

		// Update view_layers
		if(!clampToLevelBounds || pxWidth<level.pxWidth)
			view_layers.x = -focus.x + pxWidth*0.5;
		else
			view_layers.x = pxWidth*0.5 - level.pxWidth*0.5;

		if(!clampToLevelBounds || pxHeight<level.pxHeight)
			view_layers.y = -focus.x + pxHeight*0.5;
		else
			view_layers.y = pxHeight*0.5 - level.pxHeight*0.5;

		// Clamp
		if(clampToLevelBounds ) {
			if(pxWidth<level.pxWidth)
				view_layers.x = M.fclamp(view_layers.x, pxWidth-level.pxWidth, 0);
			if(pxHeight<level.pxHeight)
				view_layers.y = M.fclamp(view_layers.y, pxHeight-level.pxHeight, 0);
		}

		// Bumps friction
		bumpOffX *= Math.pow(0.75, tmod);
		bumpOffY *= Math.pow(0.75, tmod);

		// Bump
		view_layers.x += bumpOffX;
		view_layers.y += bumpOffY;

		// Shakes
		if(cd.has("shaking") ) {
			view_layers.x += Math.cos(ftime*1.1)*2.5*shakePower * cd.getRatio("shaking");
			view_layers.y += Math.sin(0.3+ftime*1.7)*2.5*shakePower * cd.getRatio("shaking");
		}

		// Scaling
		view_layers.x*=Const.SCALE;
		view_layers.y*=Const.SCALE;

		// Rounding
		view_layers.x = M.round(view_layers.x);
		view_layers.y = M.round(view_layers.y);
	}


	override function postUpdate() {
		super.postUpdate();

		if(!ui.Console.ME.hasFlag("scroll") )
			apply();
	}


	override function update() {
		super.update();

		// Follow target entity
		if(target!=null ) {
			var s = 0.006;
			var deadZone = 5;
			var tx = target.centerX;
			var ty = target.centerY;

			var d = M.dist(focus.x, focus.y, tx, ty);
			if(d>=deadZone ) {
				var a = Math.atan2(ty-focus.y, tx-focus.x);
				dx += Math.cos(a) * (d-deadZone) * s * tmod;
				dy += Math.sin(a) * (d-deadZone) * s * tmod;
			}
		}

		// Movements
		var frict = 0.89;
		focus.x += dx*tmod;
		dx *= Math.pow(frict,tmod);

		focus.x += dy*tmod;
		dy *= Math.pow(frict,tmod);
	}

}