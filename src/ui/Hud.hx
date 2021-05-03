package ui;

class Hud extends Process {
	var flow : h2d.Flow;
	var invalidated = true;
	public var g : h2d.Graphics;

	var energyMarker:Float;
	var energyChargeRate = 0.005;

	public function new() {
		super(game);

		createRootInLayers(game.root, Const.UI_LAYER);

		g = new h2d.Graphics();
		root.add(g, Const.UI_LAYER);

		energyMarker = game.energy.getNormalizedEnergy();

		flow = new h2d.Flow(root);
	}

	override function onResize() {
		super.onResize();
	}

	public inline function invalidate() invalidated = true;

	function render() {}

	override function update() {

		var energyStep = energyChargeRate * tmod;
		var energyDiff = Math.abs(game.energy.getNormalizedEnergy() - energyMarker);

		if(energyDiff < energyStep) {
			energyMarker = game.energy.getNormalizedEnergy();
		} else {
			if(energyMarker < game.energy.getNormalizedEnergy()) {
				energyMarker += energyChargeRate * tmod;
			}
			else if(energyMarker > game.energy.getNormalizedEnergy()) {
				energyMarker -= energyChargeRate * tmod;
			}
		}

	}

	override function postUpdate() {
		super.postUpdate();

		var barWidth = game.energy.getNormalizedMaxEnergy() * 200;
		var energyWidth = game.energy.getNormalizedEnergy() * 200;
		//var energyWidth = energyMarker * 200;

		if(energyWidth < 0) energyWidth = 0;

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
