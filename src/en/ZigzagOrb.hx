package en;

import echo.Body;

class ZigzagOrb extends en.Orb {
	public function new(sx, sy, physWorld:echo.World) {
		super(sx, sy, physWorld);

		radius = 64;
		energy = 12;

		body = new Body({
			x: sx,
			y: sy,
			material: {
				elasticity: 1,
			},
			mass: 0.8,
			drag_length: 0.0,
			max_velocity_length: 6,
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

	function changeDir() {
		var newVel = Vector2.from_radians(M.frandRange(0, 2 * Math.PI), M.randRange(3, 6));
		body.velocity.set(newVel.x, newVel.y);
	}

	public override function preUpdate() {}
	public override function postUpdate() {}

	public override function fixedUpdate() {
		var randChoice = M.frand();

		if(randChoice < 0.03) {
			changeDir();
		}
	}

	public override function update() {
		super.update();
	}

	public override function render() {
		g.lineStyle(3, M.randRange(0x000000, 0xFFFFFF));
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 50) * 5, this.radius + Math.sin(game.stime * 50) * -5);
	}

	public override function getParticleColor() {
		return M.randRange(0x000000, 0xFFFFFF);
	}
}
