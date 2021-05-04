package en;

import hxmath.math.Vector2;
import echo.Body;

class LazyOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy, physWorld);
		
		radius = 48;

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
		initialVel = initialVel.normal * 1.5;

		body.velocity = initialVel;

		physWorld.add(body);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		// g.clear();

		// g.lineStyle(2, 0xFFFFFF);
		// g.drawCircle(centerX, centerY, this.radius);
	}
}
