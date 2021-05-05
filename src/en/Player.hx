package en;

import hxmath.math.Vector2;
import echo.Body;

class Player extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var charge : Float;
	public var charging : Bool;
	public var chargeRate = 0.25;
	public var chargeMax = 10;
	public var prevLanceVel: Vector2;

	public function new(sx, sy) {
		super(sx, sy);

		g = new h2d.Graphics();
		//g.filter = new h2d.filter.Glow(0x0000FF, 0.7, 5.0, 1.7, 100.0, true );

		world.root.add(g, Const.MIDGROUND_OBJECTS);

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 0.2,
			mass: 1.5,
			kinematic: false,
			drag_length: 0.02,
			shapes: [
				{
					type: CIRCLE,
					radius: 2,
					offset_y: -40,
				},
				{
					type: POLYGON,
					vertices: [
						new Vector2(0, -40),
						new Vector2(-10, 40),
						new Vector2(0, 15),
						new Vector2(10, 40),
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

    	//body.entity = this;

		events.subscribe('charge_vector', chargeVector);
		events.subscribe('launch_vector', launchVector);
	}

	public override function reset() {
		charge = 1;
		prevLanceVel = new Vector2(0, -1);

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

	function chargeVector(params: Dynamic) {
		if(game.energy.getEnergy() > 0) {
			charging = true;
			charge = 1;
			this.body.velocity.set(0, 0);
		}
	}

	function launchVector(params: Dynamic) {
		if(charging == true) {
			charging = false;
			var newVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
			body.velocity = newVec.normal * charge * 1.2;
			alignToVelocity();
			
			body.velocity.copyTo(prevLanceVel);
	
			game.energy.removeEnergy(charge);
	
			charge = 0;
		}
	}

	public function getNormalizedCharge() {
		return charge / chargeMax;
	}

	public function alignToVelocity() {
		body.rotation = Math.atan2(body.velocity.y, body.velocity.x) * (180 / Math.PI) + 90;
	}

    public override function update() {
		centerX = body.x;
		centerY = body.y;

		if(charging) {
			charge += chargeRate * tmod;
		}

		if(charge > chargeMax) {
			charge = chargeMax;
		}

		g.clear();
		g.lineStyle(1, 0x0000FF);

		var ang = prevLanceVel.angle + (Math.PI / 2);

		// lance tip: 0, -40
		var tipRotX = (0) * Math.cos(ang) - (-40) * Math.sin(ang);
		var tipRotY = (-40) * Math.cos(ang) + (0) * Math.sin(ang);

		// left wing: -10, 40
		var leftRotX = (-10) * Math.cos(ang) - (40) * Math.sin(ang);
		var leftRotY = (40) * Math.cos(ang) + (-10) * Math.sin(ang);

		// bottom: 0, 15
		var botRotX = (0) * Math.cos(ang) - (15) * Math.sin(ang);
		var botRotY = (15) * Math.cos(ang) + (0) * Math.sin(ang);

		// right wing: 10, 40
		var rightRotX = (10) * Math.cos(ang) - (40) * Math.sin(ang);
		var rightRotY = (40) * Math.cos(ang) + (10) * Math.sin(ang);

		g.addVertex(centerX + tipRotX, centerY + tipRotY, 1.0, 0.0, 0.0, 1.0);
		g.addVertex(centerX + leftRotX, centerY + leftRotY, 0.5, 0.0, 0.5, 1.0);
		g.addVertex(centerX + botRotX, centerY + botRotY, 0.5, 0.0, 0.5, 1.0);
		g.addVertex(centerX + rightRotX, centerY + rightRotY, 0.5, 0.0, 0.5, 1.0);
		g.addVertex(centerX + tipRotX, centerY + tipRotY, 1.0, 0.0, 0.0, 1.0);

		var homeVec = new Vector2(world.target.x - centerX, world.target.y - centerY);
		homeVec = homeVec.normal * 80;

		g.lineStyle(1, 0x0000FF);
		g.moveTo(centerX, centerY);
		g.lineTo(homeVec.x + centerX, homeVec.y + centerY);

		var sprig1 = Vector2.fromPolar(homeVec.angle + (Math.PI / 4) * 3, 10);
		var sprig2 = Vector2.fromPolar(homeVec.angle + (Math.PI / 4) * 5, 10);

		g.moveTo(homeVec.x + centerX, homeVec.y + centerY);
		g.lineTo(homeVec.x + centerX + sprig1.x, homeVec.y + centerY + sprig1.y);

		g.moveTo(homeVec.x + centerX, homeVec.y + centerY);
		g.lineTo(homeVec.x + centerX + sprig2.x, homeVec.y + centerY + sprig2.y);

		var mouseVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
		var aimVec = mouseVec.normal * Math.max(charge, 1) * 15;

		g.lineStyle(1, 0xFF0000);
		g.moveTo(centerX, centerY);
		g.lineTo(aimVec.x + centerX, aimVec.y + centerY);

		sprig1 = Vector2.fromPolar(aimVec.angle + (Math.PI / 4) * 3, 10);
		sprig2 = Vector2.fromPolar(aimVec.angle + (Math.PI / 4) * 5, 10);

		g.moveTo(aimVec.x + centerX, aimVec.y + centerY);
		g.lineTo(aimVec.x + centerX + sprig1.x, aimVec.y + centerY + sprig1.y);

		g.moveTo(aimVec.x + centerX, aimVec.y + centerY);
		g.lineTo(aimVec.x + centerX + sprig2.x, aimVec.y + centerY + sprig2.y);

	}
}
