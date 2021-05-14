package en;

import hxmath.math.Vector2;
import echo.Body;

class HappyOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		
		super(sx, sy, physWorld);
		
		radius = 72;
		energy = 30;

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

		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 0.6;

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
		g.lineStyle(3, 0xFF00FF);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 4, this.radius + Math.sin(game.stime * 10) * -4);
		//g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * -4, this.radius + Math.sin(game.stime * 10) * 4);
		//g.drawPieInner(centerX, centerY, this.radius, 0, Math.PI * 1.5, Math.PI);
	}

	public override function getParticleColor() {
		return 0xFF00FF;
	}
}
