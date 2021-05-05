package en;

import h3d.shader.Bloom;
import hxmath.math.Vector2;
import echo.Body;
import proc.OrbManager;

class Orb extends Entity {
	public var body:Body;
	public var g : h2d.Graphics;

	public var energyOrbs: Array<EnergyOrb>;

	public var radius = 48.0;
	public var energy = 0;
	public var breakable = true;

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy);

		g = new h2d.Graphics();

		world.root.add(g, Const.MIDGROUND_OBJECTS);

		energyOrbs = [];
	}

	public function generateEnergy() {
		energyOrbs = [for(i in 0...energy) {
			pos: new Vector2(0, 0),
			vel: Vector2.fromPolar(M.frandRange(0, 2 * Math.PI), (1 / radius) * 30),
			destroyed: false
		}];
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		centerX = body.x;
		centerY = body.y;

		g.clear();
		g.beginFill(0xFFFFFF);

		for(e in energyOrbs) {
			e.pos.set(e.pos.x + e.vel.x, e.pos.y + e.vel.y);

			if(e.pos.length >= radius - 5) {
				e.vel = Vector2.fromPolar(M.frandRange(0, 2 * Math.PI), (1 / radius) * 30);
			}

			if(e.pos.length > radius - 5) {
				e.pos = e.pos.normal * (radius - 5);
			}

			g.drawCircle(e.pos.x + centerX, e.pos.y + centerY, 4);
		}

		g.endFill();
	}

	public function explode() {
		game.energy.addEnergy(energy);

		for(o in energyOrbs) {
			o.pos.set(o.pos.x + centerX, o.pos.y + centerY);
		}

		world.orbManager.looseEnergyOrbs = world.orbManager.looseEnergyOrbs.concat(energyOrbs);
		energyOrbs = [];

        destroy();
    }

	override public function destroy() {
		super.destroy();

		g.clear();
		body.dispose();
	}
}
