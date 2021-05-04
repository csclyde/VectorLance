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
	public var debug:HeapsDebug;
	public var bgTile: h2d.Tile;
	public var g : h2d.Graphics;

	public var player : en.Player;
	public var worldSpeed: Float;

	public var orbManager: OrbManager;

	var invalidated = true;

	public function new() {
		super(game);

		worldSpeed = 1.0;
		
		physWorld = new echo.World({
			width: 1,
			height: 1,
		});

		physWorld.listen({
			enter: onCollision
		});

		createRoot(game.root);
		
		g = new h2d.Graphics();
		root.add(g, Const.BACKGROUND_OBJECTS);
		debug = new HeapsDebug(root);

		bgTile = hxd.Res.space.toTile();

		
		delayer.addF('create_stuff', () -> {
			player = new en.Player(0, 0);
			physWorld.add(player.body);
			camera.trackEntity(player);
			orbManager = new OrbManager();
				
		}, 1 );

	}

	function cullDistantOrbs() {

	}

	function onCollision(a:Body, b:Body, c:Array<CollisionData>) {
		
		if(a == player.body) {
			var lanceTip = null;
			var orbTarget = null;

			//if one of the coliding shapes is not solid, we are hitting the buffer around that shape
			for(cd in c) {
				if(cd.sa.solid && cd.sa.type == CIRCLE) {
					lanceTip = cd.sa;
					orbTarget = b;
				}
			}

			//if the lance tip was involved in the collision
			if(lanceTip != null) {
				var orbVec = new Vector2(lanceTip.x - orbTarget.x, lanceTip.y - orbTarget.y);
				var lanceVec = new Vector2(lanceTip.x - a.x, lanceTip.y - a.y);
				var angleDiff = orbVec.angleWith(lanceVec) * (180 / Math.PI);

				
				if(angleDiff > 170 && angleDiff < 190) {
					trace('Dead on at ' + angleDiff);
					var orb = orbManager.findOrbFromCollision(a, b);
					if(orb != null) orb.explode();
				}
				else if(angleDiff > 150 && angleDiff < 210) {
					trace('Hit at ' + angleDiff);

					
					var orb = orbManager.findOrbFromCollision(a, b);
					if(orb != null) orb.explode();

					// delayer.addMs('explode_orb', () -> {
					// }, 100);

					// tw.createMs(worldSpeed, 0.01, TEaseIn, 200);
					// delayer.addMs('speed_up', () -> {
					// 	tw.createMs(worldSpeed, 1.0, TEaseOut, 300);
					// }, 500);
				}
				else if(angleDiff > 130 && angleDiff < 230) {
					trace('Near glance at ' + angleDiff);
					player.alignToVelocity();
				}
				else {
					trace('Far glance at ' + angleDiff);
					player.alignToVelocity();

				}

				//orbTarget.mass = 0;
			}

			// 	tw.createMs(worldSpeed, 0.2, TEaseIn, 100);
			// 	delayer.addMs('speed_up', () -> tw.createMs(worldSpeed, 1.0, TEaseOut, 200), 200);
		}
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

	}

	override function postUpdate() {
		super.postUpdate();

		g.clear();
		g.tileWrap = true;
		g.beginTileFill(0, 0, 1, 1, bgTile);        
        g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 

		//debug.draw(physWorld);

		if(invalidated) {
			invalidated = false;
			render();
		}
	}
}