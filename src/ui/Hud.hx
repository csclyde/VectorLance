package ui;

import hxmath.math.Vector2;

class Hud extends Process {
	var flow : h2d.Flow;
	public var g : h2d.Graphics;
	public var logo: h2d.Bitmap;

	var energyMarker:Float;
	var energyChargeRate = 0.005;

	var distText: h2d.Text;
	var menuText: h2d.Text;

	var inTitle = true;

	public function new() {
		super(game);

		createRootInLayers(game.root, Const.UI_LAYER);

		g = new h2d.Graphics();
		root.add(g, Const.UI_LAYER);
		g.alpha = 0;

		reset();

		flow = new h2d.Flow(root);

		distText = new h2d.Text(Assets.bubbleFont);
		distText.text = "";
		distText.textAlign = Center;
		distText.x = camera.pxWidth / 2;
		distText.y = 10;
		root.add(distText, Const.UI_LAYER);
		distText.alpha = 0;

		logo = new h2d.Bitmap(hxd.Res.logo.toTile());
		logo.x = (camera.pxWidth / 2) - (logo.tile.width / 2);
		logo.y = 200;
		root.add(logo, Const.UI_LAYER);

		events.subscribe('launch_vector', (params:Dynamic) -> {
			if(inTitle) {
				tw.createMs(logo.alpha, 0, TEaseOut, 1000);
				tw.createMs(distText.alpha, 1, TEaseOut, 1000);
				tw.createMs(g.alpha, 1, TEaseOut, 1000);
				inTitle = false;
			}
		});
	}

	override function onResize() {
		super.onResize();
	}

	override function reset() {
		energyMarker = game.energy.getNormalizedEnergy();
	}

	override function fixedUpdate() {
		var distVec = new Vector2(world.target.x - world.player.centerX, world.target.y - world.player.centerY);

		distText.text = Math.floor(distVec.length / 50) + "m to Target";
	}

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

		if(energyWidth < 0) energyWidth = 0;

		g.clear();
		g.lineStyle(1, 0x0000FF);
		g.drawRect(10, 10, barWidth + 6, 30);
		g.drawRect(12, 12, barWidth + 2, 26);

		g.lineStyle(0, 0x0000FF);

		g.beginFill(0xFFFFFF);
		g.drawRect(14, 14, energyWidth, 24);
		g.endFill();

		g.lineStyle(1, 0xFF0000);
		g.drawCircle(input.mouseX, input.mouseY, 5);
	}
}
