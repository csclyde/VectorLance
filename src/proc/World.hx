package proc;

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

	var invalidated = true;

	public function new() {
		super(Game.inst);

		physWorld = new echo.World({
			width: engine.width,
			height: engine.height,
			gravity_y: 0
		});

		g = new h2d.Graphics();
		//game.root.add(g, Const.BACKGROUND_OBJECTS);
		createRootInLayers(game.root, Const.MIDGROUND_OBJECTS);

		root.add(g, Const.BACKGROUND_OBJECTS);

		bgTile = hxd.Res.space.toTile();
	}

	/** TRUE if given coords are in level bounds **/
	public inline function isValid(x,y) return x >= 0 && x < pxWidth && y >= 0 && y < pxHeight;

	/** Ask for a level render that will only happen at the end of the current frame. **/
	public inline function invalidate() {
		invalidated = true;
	}

	function render() {
		// Placeholder level render
	}

	override function preUpdate() {
		physWorld.step(tmod);
	}

	override function postUpdate() {
		super.postUpdate();

		g.clear();

		// g.beginFill(0x000000);
		// g.drawRect(camera.focus.x - camera.pxWidth * 0.5, camera.focus.y - camera.pxHeight * 0.5, camera.pxWidth, camera.pxHeight);

		g.tileWrap = true;
		g.beginTileFill(camera.levelToGlobalX(camera.left), camera.levelToGlobalY(camera.top), 1, 1, bgTile);        
        g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}