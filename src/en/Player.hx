package en;

import hxmath.math.Vector2;
import echo.Body;
import echo.data.Options.BodyOptions;

class Player extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

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

		level.world.add(body);

		body.velocity.x = 1;

		game.e.subscribe('launch_vector', launchVector);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

	function launchVector(params: Dynamic) {
		body.velocity.x = 2;

		var newVec = new Vector2(input.mouseWorldX - body.x, input.mouseWorldY - body.y);
		body.velocity = newVec.normal * 3;
	}

    public override function update() {
		centerX = body.x;
		centerY = body.y;

		g.clear();

		g.beginFill(0xff0000);
		g.drawCircle(centerX, centerY, 16);

		g.lineStyle(1, 0xFF00FF);
		g.moveTo(centerX, centerY);
		g.lineTo(input.mouseWorldX, input.mouseWorldY);
	}
}
