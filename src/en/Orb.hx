package en;

import hxmath.math.Vector2;
import echo.Body;
import echo.data.Options.BodyOptions;

class Orb extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var radius = 32.0;

	public function new(sx, sy) {
		super(sx, sy);

		// Some default rendering for our character
		g = new h2d.Graphics();
		Game.inst.root.add(g, Const.MIDGROUND_OBJECTS);

		body = new Body({
			x: sx,
			y: sy,
			elasticity: 0.2,
			drag_length: 0.0,
			shape: {
				type: CIRCLE,
				radius: this.radius,
			}
		});
    	//body.entity = this;

		body.velocity.x = -1;

		world.physWorld.add(body);
	}

	public function setupCollision(world: echo.World, player: en.Player) {
		world.listen(player.body, this.body, {
			separate: true,
			enter: collidePlayer
		});
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
