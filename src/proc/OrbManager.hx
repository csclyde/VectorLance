package proc;

import echo.Body;

class OrbManager extends Process {

	public var orbs: Array<en.Orb>;

	public function new() {
		super(game);

		orbs = [];

		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
	}

	public function addOrb() {
		var testOrb = new en.Orb(M.randRange(camera.left, camera.right), M.randRange(camera.top, camera.bottom), world.physWorld);
		orbs.push(testOrb);
	}

	public function findOrbFromCollision(a:Body, b:Body) {
		for(o in orbs) {
			if(o.body == a || o.body == b) return o;
		}

		return null;
	}

	function cullDistantOrbs() {

	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();
	}
}