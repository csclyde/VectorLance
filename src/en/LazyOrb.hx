package en;

import hxmath.math.Vector2;
import echo.Body;

class LazyOrb extends en.Orb {

	public function new(sx, sy, physWorld: echo.World) {
		
		super(sx, sy, physWorld);

		//g.filter = new Glow(0x00FF00, 0.6, 15.0, 2.3, 20.0, true);

		
		radius = 56;
		energy = 8;
		
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
		g.lineStyle(1, 0x00FF00);
		g.drawEllipse(centerX, centerY, this.radius + (Math.sin(game.stime * 10)) * 3, this.radius + Math.sin(game.stime * 10) * -3);
		//g.drawPieInner(centerX, centerY, this.radius, 0, Math.PI * 1.5, Math.PI);
	}
}
