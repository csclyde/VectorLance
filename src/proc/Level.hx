package proc;

class Level extends dn.Process {
	var game(get,never) : Game; inline function get_game() return Game.inst;
	var fx(get,never) : Fx; inline function get_fx() return Game.inst.fx;
	var camera(get,never) : Camera; inline function get_camera() return Game.inst.camera;
	var input(get,never) : Input; inline function get_input() return Game.inst.input;

	public var pxWidth : Int;
	public var pxHeight : Int; 

	var invalidated = true;

	public function new() {
		super(Game.inst);
		createRootInLayers(Game.inst.view_layers, Const.BACKGROUND_OBJECTS);
	}

	/** TRUE if given coords are in level bounds **/
	public inline function isValid(x,y) return x >= 0 && x < pxWidth && y >= 0 && y < pxHeight;

	/** Ask for a level render that will only happen at the end of the current frame. **/
	public inline function invalidate() {
		invalidated = true;
	}

	function render() {
		// Placeholder level render
		root.removeChildren();
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}