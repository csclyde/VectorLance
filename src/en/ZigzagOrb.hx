package en;

import hxmath.math.Vector2;
import echo.Body;

class ZigzagOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy, physWorld);

		radius = 64;
		energy = 8;

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
		initialVel = initialVel.normal * 3;

		world.delayer.addMs('change_dir', changeDir, M.randRange(500, 3000));

		body.velocity = initialVel;
	}

	function changeDir() {
		if(destroyed || body == null) {
			return;
		}
		
		var newVel = Vector2.fromPolar(M.frandRange(0, 2 * Math.PI), 3);
		body.velocity.set(newVel.x, newVel.y);

		world.delayer.addS('change_dir', changeDir, M.randRange(3, 6));
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		super.update();

		g.clear();
		g.lineStyle(2, 0xFFFFFF);
		g.drawEllipse(centerX, centerY, this.radius + Math.sin(game.stime * 50) * 3, this.radius + Math.sin(game.stime * 50) * -3);
	}
}
