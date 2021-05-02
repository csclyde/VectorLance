package ui;

class Hud extends Process {
	var flow : h2d.Flow;
	var invalidated = true;
	public var g : h2d.Graphics;

	public function new() {
		super(game);

		createRootInLayers(game.root, Const.UI_LAYER);

		g = new h2d.Graphics();
		root.add(g, Const.UI_LAYER);

		flow = new h2d.Flow(root);
	}

	override function onResize() {
		super.onResize();
	}

	public inline function invalidate() invalidated = true;

	function render() {}

	override function postUpdate() {
		super.postUpdate();

		var barWidth = game.energy.getMaxEnergy() * 2;
		var energyWidth = game.energy.getEnergy() * 2;

		g.clear();
		g.lineStyle(1, 0x0000FF);
		g.drawRect(10, 10, barWidth + 4, 30);
		g.drawRect(12, 12, barWidth + 2, 26);

		g.lineStyle(0, 0x0000FF);

		g.beginFill(0xFFFFFF);
		g.drawRect(14, 14, energyWidth, 24);
		g.endFill();


		if(invalidated) {
			invalidated = false;
			render();
		}
	}
}
