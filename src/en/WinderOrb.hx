package en;

import hxmath.math.Vector2;
import echo.Body;

class WinderOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		
		super(sx, sy, physWorld);
		
		radius = 48;
		energy = 10;
		
		body = new Body({
			x: sx,
			y: sy,
			elasticity: 1,
			mass: 0.8,
			drag_length: 0.0,
			max_velocity_length: 3,
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
		initialVel = initialVel.normal * 4;

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
		body.velocity = Vector2.fromPolar(body.velocity.normal.angle + Math.sin(game.stime) * Math.PI / 200, 3.0);

		g.lineStyle(3, 0xFFFF00);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * 3, this.radius + Math.cos(game.stime * 10) * 3);
		g.lineStyle(3, 0x00FFFF);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 10) * -3, this.radius + Math.cos(game.stime * 10) * -3);
	}
}
