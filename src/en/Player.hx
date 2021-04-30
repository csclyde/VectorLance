package en;

import hxmath.math.Vector2;
import echo.Body;
import echo.data.Options.BodyOptions;

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

		// Some default rendering for our character
		g = new h2d.Graphics();
		Game.inst.root.add(g, Const.MIDGROUND_OBJECTS);

		prevLanceVel = new Vector2(0, -1);

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 0.2,
			drag_length: 0.045,
			shapes: [
				{
					type: CIRCLE,
					radius: 2,
					offset_y: -30,
				},
				{
					type: POLYGON,
					vertices: [
						new Vector2(0, -30),
						new Vector2(-10, 30),
						new Vector2(0, 15),
						new Vector2(10, 30),
					]
				},
				{
					type: CIRCLE,
					radius: 16,
					offset_y: -30,
					solid: false
				}
			]
		});
    	//body.entity = this;

		charge = 1;
		game.e.subscribe('charge_vector', chargeVector);
		game.e.subscribe('launch_vector', launchVector);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

	function chargeVector(params: Dynamic) {
		charging = true;
	}

	function launchVector(params: Dynamic) {
		charging = false;
		trace(charge);
		var newVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
		body.velocity = newVec.normal * charge;
		body.rotation = Math.atan2(body.velocity.y, body.velocity.x) * (180 / Math.PI) + 90;

		charge = 1;

		body.velocity.copyTo(prevLanceVel);
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

		// g.clear();

		// g.beginFill(0xff0000);
		// g.drawCircle(centerX, centerY, 16);

		// var ang = prevLanceVel.angle + (Math.PI / 2);

		// // lance tip: 0, -30
		// var tipRotX = (0) * Math.cos(ang) - (-30) * Math.sin(ang);
		// var tipRotY = (-30) * Math.cos(ang) + (0) * Math.sin(ang);

		// // left wing: -10, 30
		// var leftRotX = (-10) * Math.cos(ang) - (30) * Math.sin(ang);
		// var leftRotY = (30) * Math.cos(ang) + (-10) * Math.sin(ang);

		// // bottom: 0, 15
		// var botRotX = (0) * Math.cos(ang) - (15) * Math.sin(ang);
		// var botRotY = (15) * Math.cos(ang) + (0) * Math.sin(ang);

		// // right wing: 10, 30
		// var rightRotX = (10) * Math.cos(ang) - (30) * Math.sin(ang);
		// var rightRotY = (30) * Math.cos(ang) + (10) * Math.sin(ang);

		// g.addVertex(centerX + tipRotX, centerY + tipRotY, 1.0, 0.0, 0.0, 1.0);
		// g.addVertex(centerX + leftRotX, centerY + leftRotY, 0.5, 0.0, 0.5, 1.0);
		// g.addVertex(centerX + botRotX, centerY + botRotY, 0.5, 0.0, 0.5, 1.0);
		// g.addVertex(centerX + rightRotX, centerY + rightRotY, 0.5, 0.0, 0.5, 1.0);

		// var mouseVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
		// var aimVec = mouseVec.normal * charge * 10;


		// g.lineStyle(2, 0xFF0000);
		// g.moveTo(centerX, centerY);
		// g.lineTo(aimVec.x + centerX, aimVec.y + centerY);
	}
}
