package ui;

class Hud extends Process {
	var flow : h2d.Flow;
	var invalidated = true;

	public function new() {
		super(game);

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
