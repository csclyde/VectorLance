package en;

import echo.Body;

class NuttyOrb extends en.Orb {
	public function new(sx, sy, physWorld:echo.World) {
		super(sx, sy, physWorld);

		radius = 22;
		energy = 25;
		body = new Body({
			x: sx,
			y: sy,
			material: {
				elasticity: 1,
			},
			mass: 0.8,
			drag_length: 0.0,
			shapes: [
				{
					type: CIRCLE,
					radius: this.radius,
				}
			]
		});
		// body.entity = this;

		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 4.0;

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
		g.lineStyle(3, 0xC0C0C0);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 4, this.radius + Math.sin(game.stime * 10) * -4);
	}

	public override function getParticleColor() {
		return 0xC0C0C0;
	}
}
