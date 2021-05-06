package proc;

import hxmath.math.Vector2;
import echo.data.Data.CollisionData;
import echo.util.Debug.HeapsDebug;
import echo.Body;
import echo.World;

class World extends Process {
	public var pxWidth : Int;
	public var pxHeight : Int;
	
	public var physWorld:echo.World;
	public var worldSpeed: Float;
	public var debug:HeapsDebug;
	public var g : h2d.Graphics;

	public var background : Background;
	public var player : en.Player;
	public var orbManager: OrbManager;

	public var target: Vector2;

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

		target = Vector2.fromPolar(M.frandRange(0, 2 * M.PI), 50000);

		delayer.addF('create_stuff', () -> {
			player = new en.Player(0, 0);
			physWorld.add(player.body);
			camera.trackEntity(player);
			orbManager = new OrbManager();

			reset();
		}, 1 );

	}

	function cullDistantOrbs() {

	}

	function onCollision(a:Body, b:Body, c:Array<CollisionData>) {
		
		if(a == player.body) {
			var lanceTip = null;
			var orbShape = null;
			var orbEntity = orbManager.findOrbFromCollision(a, b);

			if(!orbEntity.breakable) {
				return;
			}

			//if one of the coliding shapes is not solid, we are hitting the buffer around that shape
			for(cd in c) {
				if(cd.sa.solid && cd.sa.type == CIRCLE) {
					lanceTip = cd.sa;
					orbShape = b;
				}
			}

			//if the lance tip was involved in the collision
			if(lanceTip != null) {
				var orbVec = new Vector2(lanceTip.x - orbShape.x, lanceTip.y - orbShape.y);
				var lanceVec = new Vector2(lanceTip.x - a.x, lanceTip.y - a.y);
				var angleDiff = orbVec.angleWith(lanceVec) * (180 / Math.PI);

				
				if(angleDiff > 170 && angleDiff < 190) {
					if(orbEntity != null) orbEntity.explode();
				}
				else if(angleDiff > 130 && angleDiff < 230) {
					if(orbEntity != null) orbEntity.explode();

					// delayer.addMs('explode_orb', () -> {
					// }, 100);

					// tw.createMs(worldSpeed, 0.01, TEaseIn, 200);
					// delayer.addMs('speed_up', () -> {
					// 	tw.createMs(worldSpeed, 1.0, TEaseOut, 300);
					// }, 500);
				}
				else if(angleDiff > 120 && angleDiff < 240) {
					player.alignToVelocity();
				}
				else {
					player.alignToVelocity();

				}
			}

			// 	tw.createMs(worldSpeed, 0.2, TEaseIn, 100);
			// 	delayer.addMs('speed_up', () -> tw.createMs(worldSpeed, 1.0, TEaseOut, 200), 200);
		}
	}

	override function reset() {
		worldSpeed = 1.0;

		player.reset();
		orbManager.reset();

		target = Vector2.fromPolar(M.frandRange(0, 2 * M.PI), 50000);

	}	

	function render() {
		// Placeholder level render
	}

	override function preUpdate() {
		physWorld.x = camera.left;
		physWorld.y = camera.top;
		physWorld.width = camera.pxWidth;
		physWorld.height = camera.pxHeight;

		physWorld.step(tmod * worldSpeed);
	}

	override function update() {
		super.update();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		if(game.energy.getEnergy() <= 0 && player.body.velocity.length < 0.001) {
			game.reset();
		}

		var distVec = new Vector2(world.target.x - world.player.centerX, world.target.y - world.player.centerY);

		if(distVec.length < 20) {
			game.reset();
		}
	}

	override function postUpdate() {
		super.postUpdate();

		// draw targets
		g.lineStyle(2, 0xFFFFFF);
		g.drawCircle(0, 0, 72);
		g.drawCircle(0, 0, 64);
		g.drawCircle(0, 0, 56);
		g.drawCircle(0, 0, 48);

		g.drawCircle(target.x, target.y, 72);
		g.drawCircle(target.x, target.y, 64);
		g.drawCircle(target.x, target.y, 56);
		g.drawCircle(target.x, target.y, 48);

		//debug.draw(physWorld);
	}
}