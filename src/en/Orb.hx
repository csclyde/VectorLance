package en;

import hxmath.math.Vector2;
import echo.Body;

class Orb extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var radius = 48.0;

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy);

		g = new h2d.Graphics();
		world.root.add(g, Const.MIDGROUND_OBJECTS);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		centerX = body.x;
		centerY = body.y;
	}

	public function explode() {
        destroy();
		body.dispose();
		g.clear();
    }
}
