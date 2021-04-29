package proc;

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
		createRootInLayers(game.root, Const.MIDGROUND_OBJECTS);

		root.add(g, Const.BACKGROUND_OBJECTS);

		bgTile = hxd.Res.space.toTile();

		player = new en.Player(0, 0, physWorld);
		camera.trackEntity(player);

		orbs = [];

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
		if(a == player.body || b == player.body) {
			worldSpeed = 0.1;
			tw.createMs(worldSpeed, 1.0, TEaseIn, 600);
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

	override function postUpdate() {
		super.postUpdate();

		g.clear();

		g.tileWrap = true;
		g.beginTileFill(camera.levelToGlobalX(camera.left), camera.levelToGlobalY(camera.top), 1, 1, bgTile);        
        g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}