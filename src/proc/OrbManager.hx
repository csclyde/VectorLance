package proc;

import echo.Body;
import hxmath.math.Vector2;

class OrbManager extends Process {

	public var orbs: Array<en.Orb>;
	public var testedGrids: Map<String, Bool>;
	var gridSize = 128;

	public function new() {
		super(game);

		reset();
	}

	override function reset() {
		if(orbs != null) {
			for(o in orbs) {
				o.destroy();
			}
		}

		orbs = [];
		testedGrids = [];
	}

	public function addOrb(x, y, type) {
		var newOrb:en.Orb;

		switch(type) {
			case 'Lazy': newOrb = new en.LazyOrb(x, y, world.physWorld);
			case 'Snitch': newOrb = new en.SnitchOrb(x, y, world.physWorld);
			case 'Block': newOrb = new en.BlockOrb(x, y, world.physWorld);
			default: newOrb = new en.LazyOrb(x, y, world.physWorld);
		}
		
		orbs.push(newOrb);
	}

	public function findOrbFromCollision(a:Body, b:Body) {
		for(o in orbs) {
			if(o.body == a || o.body == b) return o;
		}

		return null;
	}

	function cullDistantOrbs() {
		for(orb in orbs) {
			if(orb != null && !orb.destroyed && !camera.entityOnScreen(orb, gridSize * 3)) {
				orb.destroy();
			}
		}
	}

	function generateNewOrbs() {

		var gridLeft = Math.floor((camera.left - gridSize * 2) / gridSize);
		var gridRight = Math.floor((camera.right + gridSize * 2) / gridSize);
		var gridTop = Math.floor((camera.top - gridSize * 2) / gridSize);
		var gridBottom = Math.floor((camera.bottom + gridSize * 2) / gridSize);

		for(y in gridTop...gridBottom) {
			for(x in gridLeft...gridRight) {
				testGrid(x, y);
			}
		}
	}

	function testGrid(x:Int, y:Int) {
		var gridKey = "x" + x + "y" + y;
		var distVec = new Vector2(x, y);

		//bail if its already been tested
		if(testedGrids[gridKey]) {
			return;
		}

		//mark that we tested this grid
		testedGrids[gridKey] = true;

		var randSpawn = M.frand();

		//4 pct chance of any orb spawning here
		if(randSpawn < 0.04) {
			addOrb((x * gridSize) - gridSize / 2, (y * gridSize) - gridSize / 2, getOrbType(distVec.length));
		}


	}

	function getOrbType(dist:Float) {

		var orbRand = M.frand();

		if(orbRand < 0.10) {
			return 'Snitch';
		}
		else if(orbRand < 0.30) {
			return 'Block';
		}
		else {
			return 'Lazy';
		}
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function fixedUpdate() {
		//cullDistantOrbs();

		orbs = Lambda.filter(orbs, (o) -> return o.isAlive());

		generateNewOrbs();
	}

	override function update() {
		super.update();
	}
}