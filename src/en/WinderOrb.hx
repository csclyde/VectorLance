package en;

import hxmath.math.Vector2;
import echo.Body;

class WinderOrb extends en.Orb {

	var offset: Float;

	public function new(sx, sy, physWorld: echo.World) {
		
		super(sx, sy, physWorld);
		
		radius = 48;
		energy = 10;
		offset = M.frandRange(0, 100);
		
		body = new Body({
			x: sx,
			y: sy,
			elasticity: 1,
			mass: 0.8,
			drag_length: 0.0,
			max_velocity_length: 5,
			shapes: [
				{
					type: CIRCLE,
					radius: this.radius,
				}
			]
		});
    	//body.entity = this;

		physWorld.add(body);


		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 5;

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
		var newVel = Vector2.fromPolar(body.velocity.normal.angle + Math.sin(game.stime + offset) * (game.stime / 1000), 5.0);
		body.velocity.set(newVel.x, newVel.y);

		g.lineStyle(3, 0xFFFF00);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 3, this.radius + Math.cos(game.stime * 10) * 3);
		g.lineStyle(3, 0x00FFFF);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * -3, this.radius + Math.cos(game.stime * 10) * -3);
	}

	public override function getParticleColor() {
		if(M.frand() > 0.5) {
			return 0xFFFF00;
		} else {
			return 0x00FFFF;
		}
	}
}
