package en;

import hxmath.math.Vector2;
import echo.Body;

class SnitchOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy, physWorld);
		
		radius = 32;
		energy = 20;

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 1,
			drag_length: 0.0,
			shapes: [
				{
					type: CIRCLE,
					radius: this.radius,
				}
			]
		});
    	//body.entity = this;

		//body.velocity.x = -1;

		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 2;

		body.velocity = initialVel;

		physWorld.add(body);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		super.update();

		g.clear();
		g.lineStyle(3, 0xFFD700);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 1, this.radius + Math.sin(game.stime * 10) * -1);
	}
}
