package en;

import hxmath.math.Vector2;
import echo.Body;

class SnitchOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy, physWorld);
		
		radius = 36;
		energy = 15;

		// g.filter = new Glow(0xFFD700, 0.6, 15.0, 2.3, 20.0, true);

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
		initialVel = initialVel.normal * 3;

		body.velocity = initialVel;

		physWorld.add(body);

		generateEnergy();
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		super.update();
	}

	public override function render() {
		g.lineStyle(2, 0xFFD700);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 1, this.radius + Math.sin(game.stime * 10) * -1);
	}
}
