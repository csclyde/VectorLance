package proc;

import hxmath.math.Vector2;
import echo.util.Debug;
import echo.data.Data.CollisionData;
import echo.Body;
import echo.util.Debug.HeapsDebug;
import echo.World;

class World extends dn.Process {
	var game(get,never) : Game; inline function get_game() return Game.inst;
	var fx(get,never) : Fx; inline function get_fx() return Game.inst.fx;
	var camera(get,never) : Camera; inline function get_camera() return Game.inst.camera;
	var input(get,never) : Input; inline function get_input() return Game.inst.input;

	public var pxWidth : Int;
	public var pxHeight : Int;
	
	public var physWorld:echo.World;
	public var debug:HeapsDebug;
	public var bgTile: h2d.Tile;
	public var g : h2d.Graphics;

	public var player : en.Player;
	public var orbs: Array<en.Orb>;
	public var worldSpeed: Float;

	var invalidated = true;

	public function new() {
		super(Game.inst);

		worldSpeed = 1.0;
		
		physWorld = new echo.World({
			width: 1,
			height: 1,
		});

		physWorld.listen({
			enter: onCollision
		});

		g = new h2d.Graphics();
		//game.root.add(g, Const.BACKGROUND_OBJECTS);
		createRoot(game.root);

		root.add(g, Const.BACKGROUND_OBJECTS);
		debug = new HeapsDebug(root);

		bgTile = hxd.Res.space.toTile();

		player = new en.Player(0, 0);
		physWorld.add(player.body);
		camera.trackEntity(player);

		orbs = [];

		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
		addOrb();
	}

	function addOrb() {
		var testOrb = new en.Orb(M.randRange(camera.left, camera.right), M.randRange(camera.top, camera.bottom), physWorld);
		orbs.push(testOrb);
	}

	function cullDistantOrbs() {

	}

	function onCollision(a:Body, b:Body, c:Array<CollisionData>) {
		
		if(a.entity == player) {
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
					var orb = findOrbFromCollision(a, b);
					if(orb != null) orb.explode();
				}
				else if(angleDiff > 155 && angleDiff < 205) {
					trace('Hit at ' + angleDiff);

					orbTarget.mass = 0;
					a.mass = 0;

					tw.createMs(worldSpeed, 0.1, TEaseIn, 100);
					delayer.addMs('speed_up', () -> {
						tw.createMs(worldSpeed, 1.0, TEaseOut, 200);
						orbTarget.mass = 1;
						a.mass = 1;
					}, 200);

					delayer.addMs('explode_orb', () -> {
						var orb = findOrbFromCollision(a, b);
						if(orb != null) orb.explode();
					}, 300);
				}
				else if(angleDiff > 140 && angleDiff < 220) {
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

	function findOrbFromCollision(a:Body, b:Body) {
		for(o in orbs) {
			if(o.body == a || o.body == b) return o;
		}

		return null;
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

		// g.clear();
		// g.tileWrap = true;
		// g.beginTileFill(camera.levelToGlobalX(camera.left), camera.levelToGlobalY(camera.top), 1, 1, bgTile);        
        // g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 

		debug.draw(physWorld);

		if(invalidated) {
			invalidated = false;
			render();
		}
	}
}