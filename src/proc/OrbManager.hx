package proc;

import haxe.ds.Vector;
import echo.Body;
import hxmath.math.Vector2;

typedef EnergyOrb = {
	pos: Vector2,
	vel: Vector2,
	destroyed:Bool,
}

class OrbManager extends Process {
	public var g : h2d.Graphics;
	
	public var orbs: Array<en.Orb>;
	public var testedGrids: Map<String, Bool>;
	var gridSize = 128;

	public var looseEnergyOrbs: Array<EnergyOrb>;

	public function new() {
		super(game);

		g = new h2d.Graphics();
		world.root.add(g, Const.MIDGROUND_OBJECTS);

		looseEnergyOrbs = [];

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
			case 'Happy': newOrb = new en.HappyOrb(x, y, world.physWorld);
			case 'Nutty': newOrb = new en.NuttyOrb(x, y, world.physWorld);
			case 'Winder': newOrb = new en.WinderOrb(x, y, world.physWorld);
			case 'Zigzag': newOrb = new en.ZigzagOrb(x, y, world.physWorld);
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
		
		//bail if its already been tested
		if(testedGrids[gridKey]) {
			return;
		}

		
		//mark that we tested this grid
		testedGrids[gridKey] = true;
		
		var randSpawn = M.frand();
		
		//4 pct chance of any orb spawning here
		if(randSpawn < 0.04) {
			var distVec = new Vector2(x, y);
			addOrb((x * gridSize) - gridSize / 2, (y * gridSize) - gridSize / 2, getOrbType(distVec.length));
		}
	}

	function getOrbType(dist:Float) {

		//Calculate a weight for each type of orb. The weight is then added to a rand range. This is the orb chance
		//The orb with the highest chance is spawned
		var weight = util.gauss(dist, 1.0, 0.0, 20.0);

		return 'Lazy';

		//dist ranges from 0 to 1000

		// var orbRand = M.frand();

		// if(orbRand < 0.01) {
		// 	return 'Happy';
		// }
		// else if(orbRand < 0.10) {
		// 	return 'Snitch';
		// }
		// else if(orbRand < 0.20) {
		// 	return 'Block';
		// }
		// else {
		// 	return 'Lazy';
		// }
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

		g.clear();
		g.beginFill(0xFFFFFF);

		looseEnergyOrbs.filter((e) -> return !e.destroyed);

		for(e in looseEnergyOrbs) {
			
			//var accelVec = Vector2.fromPolar(e.pos.angleWith(playerPos), 3);
			//e.vel = Vector2.lerp(e.vel, accelVec, 0.2);
			
			if(world.player.centerX < e.pos.x) {
				e.vel.x -= 0.01;
			}
			else if(world.player.centerX > e.pos.x) {
				e.vel.x += 0.01;
			}

			if(world.player.centerY < e.pos.y) {
				e.vel.y -= 0.01;
			}
			else if(world.player.centerY > e.pos.y) {
				e.vel.y += 0.01;
			}

			e.pos.set(e.pos.x + e.vel.x, e.pos.y + e.vel.y);
			//g.drawCircle(e.pos.x, e.pos.y, 4);

			var distVec = new Vector2(world.player.centerX - e.pos.x, world.player.centerY - e.pos.y);

			if(distVec.length < 100) {
				e.destroyed = true;
			}


		}

		g.endFill();
	}
}