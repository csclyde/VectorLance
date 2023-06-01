package eng;

enum ParticleShape {
	CIRCLE;
	TRIANGLE;
}

typedef GraphicsParticle = {
	pos:Vector2,
	vel:Vector2,
	shape:ParticleShape,
	radius:Int,
	color:Int,
	lifespan:Float,
	destroyed:Bool,
}

class Fx extends Process {
	public var g:h2d.Graphics;
	public var particles:Array<GraphicsParticle>;

	public function new() {
		super(game);

		reset();

		g = new h2d.Graphics();
		world.root.add(g, Const.FOREGROUND_EFFECTS);

		particles = [];
	}

	override function reset() {
		particles = [];
	}

	public function shatterOrb(radius, color, thickness) {}

	public function generateOrbParticles(orb:en.Orb) {
		var count = Math.floor(orb.radius / 1.5);

		for(i in 0...count) {
			var part = {
				pos: Vector2.from_radians(M.frandRange(0, 2 * Math.PI), orb.radius),
				vel: null,
				shape: ParticleShape.CIRCLE,
				radius: M.randRange(Math.floor(orb.radius / 20), Math.floor(orb.radius / 10)),
				color: orb.getParticleColor(),
				lifespan: M.frandRange(15, 40),
				destroyed: false,
			}

			part.vel = part.pos.normal * M.frandRange(0.2, 1);
			part.pos.set(part.pos.x + orb.centerX, part.pos.y + orb.centerY);

			particles.push(part);
		}
	}

	public function generateJetParticles(count:Int) {
		for(i in 0...count) {
			var part = {
				pos: new Vector2(world.player.centerX, world.player.centerY),
				vel: world.player.body.velocity * M.frandRange(0.1, 0.3),
				shape: ParticleShape.TRIANGLE,
				radius: M.randRange(3, 10),
				color: 0xFFFFFF,
				lifespan: M.frandRange(30, 60),
				destroyed: false,
			}

			particles.push(part);
		}
	}

	override function fixedUpdate() {
		particles = particles.filter(p -> return !p.destroyed);
	}

	override function update() {
		g.clear();

		for(p in particles) {
			p.lifespan -= tmod;

			if(p.lifespan <= 0) {
				p.destroyed = true;
				continue;
			}

			g.lineStyle(2, p.color);
			p.pos.set(p.pos.x + (p.vel.x * tmod), p.pos.y + (p.vel.y * tmod));

			if(p.shape == ParticleShape.CIRCLE) {
				g.drawCircle(p.pos.x, p.pos.y, p.radius);
			} else if(p.shape == ParticleShape.TRIANGLE) {
				g.drawCircle(p.pos.x, p.pos.y, p.radius, 3);
			}
		}
	}
}
