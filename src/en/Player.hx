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

	public function new(sx, sy) {
		super(sx, sy);

		// Some default rendering for our character
		g = new h2d.Graphics();
		Game.inst.root.add(g, Const.MIDGROUND_OBJECTS);

		body = new Body({
			x: 0,
			y: 0,
			elasticity: 0.2,
			shape: {
				type: CIRCLE,
				radius: 16,
			}
		});
    	//body.entity = this;

		world.physWorld.add(body);

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

		charge = 1;
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

		g.beginFill(0xff0000);
		g.drawCircle(centerX, centerY, 16);

		var aimVec = new Vector2(input.mouseWorldX, input.mouseWorldY);


		g.lineStyle(2, 0xFF0000);
		g.moveTo(centerX, centerY);
		g.lineTo(aimVec.x, aimVec.y);
	}
}
