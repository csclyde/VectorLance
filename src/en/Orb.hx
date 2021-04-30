package en;

import echo.shape.Circle;
import hxmath.math.Vector2;
import echo.Body;
import echo.data.Options.BodyOptions;

class Orb extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var radius = 32.0;

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy);

		// Some default rendering for our character
		g = new h2d.Graphics();
		Game.inst.root.add(g, Const.MIDGROUND_OBJECTS);

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 1,
			drag_length: 0.0,
			shapes: [
				{
					type: CIRCLE,
					radius: this.radius,
				},
				{
					type: CIRCLE,
					radius: this.radius + this.radius + this.radius,
					solid: false
				}
			]
		});
    	//body.entity = this;

		//body.velocity.x = -1;

		var initialVel = new Vector2(M.frandRange(-100, 100), M.frandRange(-100, 100));
		initialVel = initialVel.normal * 2;

		body.velocity = initialVel;

		physWorld.add(body);
	}

	public function collidePlayer(a:Body, b:Body, c:Array<echo.data.Data.CollisionData>) {
		g.clear();
		this.destroy();
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		centerX = body.x;
		centerY = body.y;

		g.clear();

		g.lineStyle(2, 0xFFFFFF);
		g.drawCircle(centerX, centerY, this.radius);
	}
}
