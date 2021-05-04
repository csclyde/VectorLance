package en;

import hxmath.math.Vector2;
import echo.Body;

class LazyOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy, physWorld);
		
		radius = 56;
		energy = 5;

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 1,
			mass: 0.8,
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
		initialVel = initialVel.normal * 1.2;

		body.velocity = initialVel;

		physWorld.add(body);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		super.update();

		g.clear();
		g.lineStyle(2, 0x00FF00);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 2, this.radius + Math.sin(game.stime * 10) * -2);
		//g.drawPieInner(centerX, centerY, this.radius, 0, Math.PI * 1.5, Math.PI);
	}
}
