package en;

import echo.Body;
import echo.shape.*;

class BlockOrb extends en.Orb {
	public function new(sx, sy, physWorld:echo.World) {
		super(sx, sy, physWorld);

		radius = M.randRange(64, 128);
		energy = 0;
		breakable = false;

		body = new Body({
			x: sx,
			y: sy,
			material: {
				elasticity: 1,
			},
			mass: 5,
			drag_length: 0.0,
			rotation: M.randRange(0, 45),
			shapes: [
				{
					type: RECT,
					width: this.radius,
				}
			]
		});
		// body.entity = this;

		var initialVel = new Vector2(0, 0);
		initialVel = initialVel.normal * 2;

		body.velocity = initialVel;

		physWorld.add(body);
	}

	public override function preUpdate() {}
	public override function postUpdate() {}
	public override function fixedUpdate() {}

	public override function update() {
		super.update();
	}

	public override function render() {
		g.lineStyle(3, 0xFF1818);

		var r:Rect = cast body.shape;

		if(r == null || r.transformed_rect == null) {
			return;
		}

		var count = r.transformed_rect.count;
		var vertices = r.transformed_rect.vertices;

		for(i in 1...count) {
			g.moveTo(vertices[i - 1].x, vertices[i - 1].y);
			g.lineTo(vertices[i].x, vertices[i].y);
		}

		var vl = count - 1;
		g.moveTo(vertices[vl].x, vertices[vl].y);
		g.lineTo(vertices[0].x, vertices[0].y);
	}
}
