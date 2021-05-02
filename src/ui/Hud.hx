package ui;

class Hud extends Process {
	public var game(get,never) : Game; inline function get_game() return Game.inst;
	public var fx(get,never) : Fx; inline function get_fx() return Game.inst.fx;
	public var world(get,never) : World; inline function get_world() return Game.inst.world;

	var flow : h2d.Flow;
	var invalidated = true;

	public function new() {
		super(Game.inst);

		createRootInLayers(game.root, Const.UI_LAYER);
		root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering

		flow = new h2d.Flow(root);
	}

	override function onResize() {
		super.onResize();
		root.setScale(Const.UI_SCALE);
	}

	public inline function invalidate() invalidated = true;

	function render() {}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}
