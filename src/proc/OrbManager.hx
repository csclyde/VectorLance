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

	public function addOrb(x, y) {
		var newOrb:en.Orb;

		//Calculate a weight for each type of orb. The weight is then added to a rand range. This is the orb chance
		//The orb with the highest chance is spawned
		var distVec = new Vector2(x, y);
		var mLen = distVec.length / 50;

		var choice = 'Lazy';
		var randHelp = M.frand();
		var spawnThreshold = 0.04;

		if(mLen < 100) {
			choice = randHelp <= 0.05 ? 'Snitch' : 'Lazy';
			spawnThreshold = 0.03;
		}
		else if(mLen < 200) {
			if(randHelp < 0.5) { choice = 'Snitch'; } 
			else if(randHelp < 0.60) { choice = 'Block'; }
			else { choice = 'Lazy'; }
			spawnThreshold = 0.04;
		}
		else if(mLen < 300) {
			if(randHelp < 0.60) { choice = 'Block'; } 
			else if(randHelp < 0.75) { choice = 'Snitch'; } 
			else { choice = 'Lazy'; }
			spawnThreshold = 0.15;
		}
		else if(mLen < 400) {
			choice = 'Nutty';
			spawnThreshold = 0.03;
		}
		else if(mLen < 500) {
			if(randHelp < 0.05) { choice = 'Happy'; }
			if(randHelp < 0.30) { choice = 'Winder'; }
			else { choice = 'Nutty'; }
			spawnThreshold = 0.03;
		}
		else if(mLen < 600) {
			choice = 'Winder';
			spawnThreshold = 0.04;
		}
		else if(mLen < 700) {
			if(randHelp < 0.50) { choice = 'Winder'; }
			else { choice = 'Zigzag'; }
			spawnThreshold = 0.04;
		}
		else if(mLen < 800) {
			choice = 'Zigzag';
			spawnThreshold = 0.10;
		}
		else if(mLen < 900) {
			choice = 'Zigzag';
			spawnThreshold = 0.04;
		}
		else if(mLen < 1000) {
			choice = 'Zigzag';
			spawnThreshold = 0.02;
		}
		else {

		}

		if(M.frand() > spawnThreshold) {
			return;
		}
		
		switch(choice) {
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
			if(!camera.entityOnScreen(orb, gridSize * 4)) {
				orb.body.active = false;
			} else {
				orb.body.active = true;
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
		
		//4 pct chance of any orb spawning here
		addOrb((x * gridSize) - gridSize / 2, (y * gridSize) - gridSize / 2);
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

		g.clear();
		g.beginFill(0xFFFFFF);

		looseEnergyOrbs = looseEnergyOrbs.filter((e) -> return !e.destroyed);

		for(e in looseEnergyOrbs) {
			
			//var accelVec = Vector2.fromPolar(e.pos.angleWith(playerPos), 3);
			//e.vel = Vector2.lerp(e.vel, accelVec, 0.2);
			
			// if(world.player.centerX < e.pos.x) {
			// 	e.vel.x -= 0.01;
			// }
			// else if(world.player.centerX > e.pos.x) {
			// 	e.vel.x += 0.01;
			// }

			// if(world.player.centerY < e.pos.y) {
			// 	e.vel.y -= 0.01;
			// }
			// else if(world.player.centerY > e.pos.y) {
			// 	e.vel.y += 0.01;
			// }

			e.pos.set(e.pos.x + e.vel.x, e.pos.y + e.vel.y);
			g.drawCircle(e.pos.x, e.pos.y, 4);

			var distVec = new Vector2(world.player.centerX - e.pos.x + world.player.body.velocity.x, world.player.centerY - e.pos.y + world.player.body.velocity.y);
			e.vel = Vector2.lerp(e.vel, distVec, 0.003);


			if(distVec.length < 20) {
				e.destroyed = true;
			}


		}

		g.endFill();
	}
}