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

	public var explosion: Emitter;

	public function new(sx, sy, physWorld: echo.World) {
		super(sx, sy);

		g = new h2d.Graphics();

		world.root.add(g, Const.MIDGROUND_OBJECTS);

		explosion = new Emitter();
		explosion.load(haxe.Json.parse(hxd.Res.particles.Orb.entry.getText()), hxd.Res.particles.Orb.entry.path);

		world.root.add(explosion, Const.FOREGROUND_EFFECTS);

		energyOrbs = [];
	}

	public override function isAlive() {
		return !destroyed && body.active;
	}

	public function generateEnergy() {
		energyOrbs = [for(i in 0...energy) {
			pos: Vector2.fromPolar(M.frandRange(0, 2 * Math.PI), M.frandRange(-radius, radius)),
			vel: Vector2.fromPolar(M.frandRange(0, 2 * Math.PI), (1 / radius) * 30),
			destroyed: false,
			timestamp: 0.0,
		}];
	}

	public function getParticleColor() {
		return 0xFFFFFF;
	}

	public function render() {}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		centerX = body.x;
		centerY = body.y;

		g.clear();
		
		if(camera.entityOnScreen(this, 200)) {
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
			
			render();
		}
	}

	public function explode() {
		game.energy.addEnergy(energy);

		for(o in energyOrbs) {
			o.vel = o.pos.normal * M.frandRange(1.5, 3);
			o.pos.set(o.pos.x + centerX, o.pos.y + centerY);
		}

		world.orbManager.looseEnergyOrbs = world.orbManager.looseEnergyOrbs.concat(energyOrbs);
		energyOrbs = [];

		fx.generateOrbParticles(this);

        destroy();
    }

	override public function destroy() {
		super.destroy();

		g.clear();
		g.clear();
		body.dispose();
	}
}
