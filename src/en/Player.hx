package en;

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
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

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
