package en;

import h3d.shader.Bloom;
import hxmath.math.Vector2;
import echo.Body;

class Orb extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var radius = 48.0;
	public var energy = 10;
	public var breakable = true;

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy);

		g = new h2d.Graphics();
		//g.filter = new h2d.filter.Bloom(1.0, 5.0, 1.0, 5.0, 1.0);

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
		game.energy.addEnergy(energy);
        destroy();
    }

	override public function destroy() {
		super.destroy();

		g.clear();
		body.dispose();
	}
}
