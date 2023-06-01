package proc;

import echo.data.Data.CollisionData;
import echo.util.Debug.HeapsDebug;
import echo.Body;
import echo.World;
import proc.Background;
import proc.OrbManager;
import proc.Energy;

class World extends Process {
	public var pxWidth:Int;
	public var pxHeight:Int;

	public var physWorld:echo.World;
	public var worldSpeed:Float;
	public var debug:HeapsDebug;
	public var g:h2d.Graphics;

	public var player:en.Player;
	public var background:Background;
	public var orbManager:OrbManager;
	public var energy:Energy;

	public var bestDist:Int;
	public var currentDist:Int;

	public var score:Int;
	public var orbStreak:Int = 0;
	var playerLaunchX:Int;
	var playerLaunchY:Int;

	public function new() {
		super(game);

		physWorld = new echo.World({
			width: 1,
			height: 1,
		});

		physWorld.listen({
			enter: onCollision
		});

		createRoot(game.root);

		g = new h2d.Graphics();
		root.add(g, Const.BACKGROUND_EFFECTS);
		debug = new HeapsDebug(root);

		background = new Background();

		delayer.addF('create_stuff', () -> {
			player = new en.Player(0, 0);
			physWorld.add(player.body);
			camera.trackEntity(player);
			orbManager = new OrbManager();
			energy = new Energy();

			// draw targets
			g.lineStyle(1, 0xFFFFFF);
			g.drawCircle(0, 0, 72);
			g.drawCircle(0, 0, 64);
			g.drawCircle(0, 0, 56);
			g.drawCircle(0, 0, 48);

			reset();
		}, 0);

		events.subscribe('collect_energy', (params:Dynamic) -> {
			var longshotMulti = cd.has('show_longshot') ? 3 : 1;
			score += 1 * player.streak * orbStreak * longshotMulti;
		});

		events.subscribe('orb_destroyed', (params:Dynamic) -> {
			orbStreak += 1;
			cd.setS('show_streak', 3);

			var shotDistVec = new Vector2(params.x - playerLaunchX, params.y - playerLaunchY);

			if(shotDistVec.length > 1000) {
				cd.setS('show_longshot', 3);
			}
		});

		events.subscribe('player_launch', (params:Dynamic) -> {
			orbStreak = 0;
			playerLaunchX = params.x;
			playerLaunchY = params.y;
		});
	}

	override function reset() {
		worldSpeed = 1.0;
		score = 0;

		player.reset();
		background.reset();
		orbManager.reset();
		energy.reset();
	}

	function onCollision(a:Body, b:Body, c:Array<CollisionData>) {
		if(a == player.body) {
			var lanceTip = null;
			var orbShape = null;
			var orbEntity = orbManager.findOrbFromCollision(a, b);

			if(!orbEntity.breakable) {
				return;
			}

			// if one of the coliding shapes is not solid, we are hitting the buffer around that shape
			for(cd in c) {
				if(cd.sa.solid && cd.sa.type == CIRCLE) {
					lanceTip = cd.sa;
					orbShape = b;
				}
			}

			// if the lance tip was involved in the collision
			if(lanceTip != null) {
				var orbVec = new Vector2(lanceTip.x - orbShape.x, lanceTip.y - orbShape.y);
				var lanceVec = new Vector2(lanceTip.x - a.x, lanceTip.y - a.y);
				var angleDiff = Math.abs(orbVec.radians_between(lanceVec) * (180 / Math.PI));

				if(angleDiff > 170 && angleDiff < 190) {
					if(orbEntity != null) orbEntity.explode();

					world.player.body.velocity = world.player.velCopy;
					world.player.body.velocity *= 1.2;

					// var newVel = world.player.body.velocity * 1.5;
					// world.player.body.velocity.set(newVel.x, newVel.y);
				} else if(angleDiff > 115 && angleDiff < 245) {
					if(orbEntity != null) orbEntity.explode();

					world.player.body.velocity = world.player.velCopy;
					world.player.body.velocity *= 1.2;

					// var newVel = world.player.body.velocity * 1.5;
					// world.player.body.velocity.set(newVel.x, newVel.y);

					// delayer.addMs('explode_orb', () -> {
					// }, 100);

					// tw.createMs(worldSpeed, 0.01, TEaseIn, 200);
					// delayer.addMs('speed_up', () -> {
					// 	tw.createMs(worldSpeed, 1.0, TEaseOut, 300);
					// }, 500);
				} else {
					player.alignToVelocity();
				}
			}

			// 	tw.createMs(worldSpeed, 0.2, TEaseIn, 100);
			// 	delayer.addMs('speed_up', () -> tw.createMs(worldSpeed, 1.0, TEaseOut, 200), 200);
		}
	}

	override function preUpdate() {
		physWorld.x = camera.left - 200;
		physWorld.y = camera.top - 200;
		physWorld.width = camera.pxWidth + 200;
		physWorld.height = camera.pxHeight + 200;

		physWorld.step(tmod * worldSpeed);
	}

	override function update() {
		super.update();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		var distVec = new Vector2(world.player.centerX, world.player.centerY);
		currentDist = Math.floor(distVec.length / 100);

		if(currentDist > bestDist) {
			bestDist = currentDist;
		}

		if(energy.getEnergy() <= 0 && world.player.body.velocity.length < 0.001) {
			reset();
		}
	}

	override function postUpdate() {
		super.postUpdate();

		// debug.draw(physWorld);
	}
}
