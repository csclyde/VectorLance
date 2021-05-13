package ui;

import hxmath.math.MathTypes.Vector2Type;
import haxe.iterators.StringIterator;
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

	var vecTex: VectorText;

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

		if(Process.PROFILING) {
			debugText = new h2d.Text(Assets.fontSmall);
			debugText.text = "60 FPS";
			debugText.textAlign = Left;
			debugText.x = 10;
			debugText.y = 50;
			root.add(debugText, Const.UI_LAYER);
		}

		logo = new h2d.Bitmap(hxd.Res.logo.toTile());
		logo.x = (camera.pxWidth / 2) - (logo.tile.width / 2);
		logo.y = 200;
		root.add(logo, Const.UI_LAYER);

		vecTex = new VectorText(g);

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

		//distText.text = Math.floor(distVec.length / 50) + '';
		
		if(Process.PROFILING) {
			debugText.text = Math.floor(Timer.fps()) + ' FPS \n\n';
			debugText.text += Entity.ALL.length + ' entities \n';
			debugText.text += Entity.AllActive().length + ' active \n\n';
	
			for(p in Process.getSortedProfilerTimes().filter(set -> return set.value >= 0.5)) {
				debugText.text += p.key + ': ' + Math.floor(p.value * 100) / 100 + '\n';
			}
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
		if(targetWidth < 0) targetWidth = 0;

		// energy bar outline
		g.clear();
		g.lineStyle(2, 0x0000FF);
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

		g.lineStyle(2, 0xFFFFFF);
		g.drawCircle(input.mouseX, input.mouseY, 5);

		var tx = Math.floor((camera.pxWidth / 2) - 160);
		var ty = 20;
		var ch = 40;
		var chh = 20;
		var cw = 20;
		var cwh = 10;
		var sw = cw + 10;

		g.lineStyle(1, 0xFFFFFF);
		vecTex.drawText(tx, ty, world.currentDist + ' FROM ORIGIN');
		g.lineStyle(1, 0xFF0000);
		vecTex.drawText(tx + 800, ty, 'BEST ' + world.bestDist);
	}
}
