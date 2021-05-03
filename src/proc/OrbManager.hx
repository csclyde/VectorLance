package proc;

import echo.Body;
import hxmath.math.Vector2;

typedef LatentOrb = {
	x:Float,
	y:Float,
	type:String,
	spawned:Bool,
}

class OrbManager extends Process {

	public var orbs: Array<en.Orb>;
	public var latentOrbs: Array<LatentOrb>;

	public function new() {
		super(game);

		orbs = [];
		latentOrbs = [];

		generateLatentOrbs();
	}

	public function addOrb(x, y, type) {
		var newOrb = new en.Orb(x, y, world.physWorld);
		orbs.push(newOrb);
	}

	public function findOrbFromCollision(a:Body, b:Body) {
		for(o in orbs) {
			if(o.body == a || o.body == b) return o;
		}

		return null;
	}

	function generateLatentOrbs() {
		var newOrb: LatentOrb;
		var orbVec: Vector2;

		for(i in 0...1000) {

			orbVec = Vector2.fromPolar(M.frandRange(0, 2.0 * Math.PI), M.randRange(0, 100000));

			newOrb = {
				x: orbVec.x,
				y: orbVec.y,
				type: 'Lazy',
				spawned: false,
			}

			latentOrbs.push(newOrb);
		}
	}

	function cullDistantOrbs() {
		for(orb in orbs) {
			if(orb != null && !orb.destroyed && !camera.entityOnScreen(orb, 100)) {
				orb.destroy();
			}
		}
	}

	function generateNewOrbs() {
		for(o in latentOrbs) {
			if(!o.spawned && camera.coordsOnScreen(o.x, o.y, 100)) {
				o.spawned = true;
				addOrb(o.x, o.y, o.type);
			}
		}
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function fixedUpdate() {
		cullDistantOrbs();

		orbs = Lambda.filter(orbs, (o) -> return o.isAlive());

		generateNewOrbs();
	}

	override function update() {
		super.update();
	}
}