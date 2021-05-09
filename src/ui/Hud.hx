package ui;

import hxd.Timer;
import hxmath.math.Vector2;

class Hud extends Process {
	var flow : h2d.Flow;
	public var g : h2d.Graphics;
	public var logo: h2d.Bitmap;

	var energyMarker:Float;
	var energyChargeRate = 0.003;

	var distText: h2d.Text;
	var debugText: h2d.Text;

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

		debugText = new h2d.Text(Assets.fontSmall);
		debugText.text = "60 FPS";
		debugText.textAlign = Left;
		debugText.x = 10;
		debugText.y = 50;
		//root.add(debugText, Const.UI_LAYER);

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

		debugText.text = Math.floor(Timer.fps()) + ' FPS \n\n';
		debugText.text += Entity.ALL.length + ' entities \n\n';
		debugText.text += Entity.AllActive().length + ' entities \n\n';

		for(p in Process.getSortedProfilerTimes().filter(set -> return set.value >= 1.0)) {
			debugText.text += p.key + ': ' + p.value + '\n';
		}
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

		var containerWidth = game.energy.getNormalizedMaxEnergy() * 200;
		var barWidth = (energyMarker) * 200;
		var targetWidth = (game.energy.getNormalizedEnergy() - ((world.player.charge) / game.energy.getMaxEnergy())) * 200;

		if(barWidth < 0) barWidth = 0;

		// energy bar outline
		g.clear();
		g.lineStyle(1, 0x0000FF);
		g.drawRect(10, 10, containerWidth + 6, 30);
		g.drawRect(12, 12, containerWidth + 2, 26);

		// energy bar
		g.lineStyle(0, 0x0000FF);
		g.beginFill(0xFFFFFF);
		g.drawRect(14, 14, barWidth, 24);
		g.endFill();

		if(targetWidth > barWidth) {
			g.beginFill(0x808080);
			g.drawRect(14 + barWidth, 14, targetWidth - barWidth, 24);
			g.endFill();
		}
		else if(targetWidth < barWidth) {
			g.beginFill(0x808080);
			g.drawRect(14 + barWidth - (barWidth - targetWidth), 14, (barWidth - targetWidth), 24);
			g.endFill();
		}


		g.lineStyle(1, 0xFF0000);
		g.drawCircle(input.mouseX, input.mouseY, 5);
	}
}
