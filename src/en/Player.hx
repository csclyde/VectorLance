package en;

import h2d.filter.Glow;
import echo.Body;

class Player extends Entity {
	public var body:Body;
	public var g:h2d.Graphics;

	public var charge:Float;
	public var charging:Bool;
	public var chargeRate = 0.25;
	public var chargeMax = 10;
	public var prevLanceVel:Vector2;
	public var velCopy:Vector2;
	public var mouseVec:Vector2;
	public var aimVec:Vector2;

	public var trail:Emitter;

	public var streak:Int;
	public var hitOrb:Bool;

	public function new(sx, sy) {
		super(sx, sy);

		g = new h2d.Graphics();

		world.root.add(g, Const.MIDGROUND_OBJECTS);

		trail = new Emitter();
		trail.load(haxe.Json.parse(hxd.Res.particles.ChargeTrail.entry.getText()), hxd.Res.particles.ChargeTrail.entry.path);

		world.root.add(trail, Const.FOREGROUND_EFFECTS);

		body = new Body({
			x: sx,
			y: sy,
			material: {
				elasticity: 0.2,
			},
			mass: 1.5,
			kinematic: false,
			drag_length: 0.03,
			shapes: [
				{
					type: CIRCLE,
					radius: 2,
					offset_y: -50,
				},
				{
					type: POLYGON,
					vertices: [
						new Vector2(0, -50),
						new Vector2(-20, 50),
						new Vector2(0, 15),
						new Vector2(20, 50),
					]
				},
				// {
				// 	type: CIRCLE,
				// 	radius: 16,
				// 	offset_y: -40,
				// 	solid: false
				// }
			]
		});

		// body.entity = this;

		velCopy = new Vector2(0, 0);
		mouseVec = new Vector2(0, 0);
		aimVec = new Vector2(0, 0);

		events.subscribe('charge_vector', chargeVector);
		events.subscribe('launch_vector', launchVector);

		events.subscribe('collect_energy', flashWhite);

		events.subscribe('orb_destroyed', (params:Dynamic) -> {
			if(hitOrb == false) {
				streak++;
				hitOrb = true;
			}
		});
	}

	public override function reset() {
		charge = 0;
		prevLanceVel = new Vector2(0, -1);

		streak = 0;
		hitOrb = false;

		centerX = 0;
		centerY = 0;

		if(body != null) {
			body.x = 0;
			body.y = 0;
			body.velocity.set(0, 0);
			body.rotation = 0;
		}
	}

	public override function preUpdate() {}
	public override function postUpdate() {}
	public override function fixedUpdate() {}

	function chargeVector(params:Dynamic) {
		if(world.energy.getEnergy() > 0) {
			charging = true;
			charge = 1;
			// this.body.velocity.set(0, 0);
			world.cd.setMs('ghost_trails', 0);

			audio.playSound(hxd.Res.sounds.charge);
		}
	}

	function launchVector(params:Dynamic) {
		if(charging == true) {
			charging = false;
			var newVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
			body.velocity = newVec.normal * charge * 1.8;
			alignToVelocity();

			prevLanceVel = body.velocity.clone();

			world.energy.removeEnergy(charge);

			trail.rotation = body.velocity.radians - (Math.PI / 2);
			trail.setCount(Math.floor(charge * 3));
			trail.play();

			// camera.shakeS(2.0, 1.0);
			world.cd.setMs('ghost_trails', 500);
			world.events.send('player_launch', {x: centerX, y: centerY});

			charge = 0;

			if(hitOrb == false) {
				streak = 0;
			}

			hitOrb = false;

			audio.stopSound(hxd.Res.sounds.charged);
			audio.playSound(hxd.Res.sounds.launch);
		}
	}

	public function getNormalizedCharge() {
		return charge / chargeMax;
	}

	public function alignToVelocity() {
		body.rotation = Math.atan2(body.velocity.y, body.velocity.x) * (180 / Math.PI) + 90;
	}

	public override function getCameraAnchorX() {
		return centerX + aimVec.x + body.velocity.x * 15;
	}

	public override function getCameraAnchorY() {
		return centerY + aimVec.y + body.velocity.y * 15;
	}

	public override function update() {
		centerX = body.x;
		centerY = body.y;

		trail.x = centerX;
		trail.y = centerY;

		mouseVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
		aimVec = mouseVec.normal * Math.max(charge, 1) * 15;

		if(charging) {
			if(charge < chargeMax) {
				charge += chargeRate * tmod;
			}
			body.drag_length = 0.3;
		} else {
			body.drag_length = 0.05;
		}

		if(charge > chargeMax) {
			charge = chargeMax;
			audio.playSound(hxd.Res.sounds.cock);
			audio.stopSound(hxd.Res.sounds.charge);
			audio.playSound(hxd.Res.sounds.charged, true);
		}

		velCopy = body.velocity.clone();

		g.clear();

		// LANCE BODY
		if(world.energy.getEnergy() <= 0) {
			drawLanceBody(centerX, centerY, prevLanceVel.radians, Math.sin(ftime / body.velocity.length));
		} else if(charge > 0) {
			drawLanceBody(centerX, centerY, aimVec.radians, 1.0);
		} else {
			drawLanceBody(centerX, centerY, prevLanceVel.radians, 1.0);
		}

		if(world.cd.has('ghost_trails')) {
			for(i in 0...5) {
				var ghostPos = prevLanceVel.normal * -30 * i * world.cd.getRatio('ghost_trails');
				var color = i % 2 == 0 ? 0xFF0000 : 0x0000FF;
				drawLanceBody(ghostPos.x + centerX, ghostPos.y + centerY, prevLanceVel.radians, world.cd.getRatio('ghost_trails') * (1 / i), color);
			}
		}

		// ORIGIN ARROW
		var originVec = new Vector2(-centerX, -centerY);
		originVec = originVec.normal * 160;

		g.lineStyle(2, 0xFFFFFF);
		g.moveTo(originVec.x / 1.2 + centerX, originVec.y / 1.2 + centerY);
		g.lineTo(originVec.x + centerX, originVec.y + centerY);

		var sprig1 = Vector2.from_radians(originVec.radians + (Math.PI / 4) * 3, 10);
		var sprig2 = Vector2.from_radians(originVec.radians + (Math.PI / 4) * 5, 10);

		g.moveTo(originVec.x + centerX, originVec.y + centerY);
		g.lineTo(originVec.x + centerX + sprig1.x, originVec.y + centerY + sprig1.y);

		g.moveTo(originVec.x + centerX, originVec.y + centerY);
		g.lineTo(originVec.x + centerX + sprig2.x, originVec.y + centerY + sprig2.y);

		// AIMING ARROW
		g.lineStyle(2, 0xFF0000);
		g.moveTo(centerX, centerY);
		g.lineTo(aimVec.x + centerX, aimVec.y + centerY);

		sprig1 = Vector2.from_radians(aimVec.radians + (Math.PI / 4) * 3, 10);
		sprig2 = Vector2.from_radians(aimVec.radians + (Math.PI / 4) * 5, 10);

		g.moveTo(aimVec.x + centerX, aimVec.y + centerY);
		g.lineTo(aimVec.x + centerX + sprig1.x, aimVec.y + centerY + sprig1.y);

		g.moveTo(aimVec.x + centerX, aimVec.y + centerY);
		g.lineTo(aimVec.x + centerX + sprig2.x, aimVec.y + centerY + sprig2.y);
	}

	function flashWhite(params:Dynamic) {
		world.cd.setMs('flashing', 50, false);

		audio.playSoundCd(hxd.Res.sounds.energy, 100);
	}

	function drawLanceBody(x:Float, y:Float, angle:Float, alpha:Float, ?color:Int = 0x0000FF) {
		if(charge >= chargeMax) {
			if(Math.sin((world.uftime)) > 0.0) {
				color = 0xFF0000;
			}
		}

		if(world.cd.has('flashing')) {
			color = 0xFFFFFF;
		}

		g.lineStyle(2, color, alpha);

		var ang = angle + (Math.PI / 2);
		var len = 50 - charge + Math.max(0, body.velocity.length - 12) * 2;
		var wid = 20 + charge - Math.max(0, body.velocity.length - 12);
		var dep = 15;

		// lance tip: 0, -40
		var tipRotX = (0) * Math.cos(ang) - (-len) * Math.sin(ang);
		var tipRotY = (-len) * Math.cos(ang) + (0) * Math.sin(ang);

		// left wing: -10, 40
		var leftRotX = (-wid) * Math.cos(ang) - (len) * Math.sin(ang);
		var leftRotY = (len) * Math.cos(ang) + (-wid) * Math.sin(ang);

		// bottom: 0, 15
		var botRotX = (0) * Math.cos(ang) - (dep) * Math.sin(ang);
		var botRotY = (dep) * Math.cos(ang) + (0) * Math.sin(ang);

		// right wing: 10, 40
		var rightRotX = (wid) * Math.cos(ang) - (len) * Math.sin(ang);
		var rightRotY = (len) * Math.cos(ang) + (wid) * Math.sin(ang);

		g.addVertex(x + tipRotX, y + tipRotY, 1.0, 0.0, 0.0, alpha);
		g.addVertex(x + leftRotX, y + leftRotY, 0.5, 0.0, 0.5, alpha);
		g.addVertex(x + botRotX, y + botRotY, 0.5, 0.0, 0.5, alpha);
		g.addVertex(x + rightRotX, y + rightRotY, 0.5, 0.0, 0.5, alpha);
		g.addVertex(x + tipRotX, y + tipRotY, 1.0, 0.0, 0.0, alpha);
	}
}
