package en;

import echo.Body;

class LazyOrb extends en.Orb {
	public function new(sx, sy, physWorld:echo.World) {
		super(sx, sy, physWorld);

		radius = 56;
		energy = 8;

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

		physWorld.add(body);

		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 3;

		body.velocity = initialVel;

		generateEnergy();
	}

	public override function preUpdate() {}
	public override function postUpdate() {}
	public override function fixedUpdate() {}

	public override function update() {
		super.update();
	}

	public override function render() {
		g.lineStyle(3, 0x39FF14);
		g.drawEllipse(centerX, centerY, this.radius + (Math.sin(game.stime * 10)) * 3, this.radius + Math.sin(game.stime * 10) * -3);
		// g.drawPieInner(centerX, centerY, this.radius, 0, Math.PI * 1.5, Math.PI);
	}

	public override function getParticleColor() {
		return 0x39FF14;
	}
}
