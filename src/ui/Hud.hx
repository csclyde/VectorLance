package ui;

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

		debugText = new h2d.Text(Assets.fontMedium);
		debugText.text = "60 FPS";
		debugText.textAlign = Left;
		debugText.x = 10;
		debugText.y = 50;
		root.add(debugText, Const.UI_LAYER);

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

		//distText.text = Math.floor(distVec.length / 50) + '';

		debugText.text = 'Power: ' + App.inst.bloomFilter.power + '\n';
		debugText.text += 'Amount: ' + App.inst.bloomFilter.amount + '\n';
		debugText.text += 'Radius: ' + App.inst.bloomFilter.radius + '\n';
		debugText.text += 'Gain: ' + App.inst.bloomFilter.gain + '\n';
		debugText.text += 'Quality: ' + App.inst.bloomFilter.quality + '\n';
		
		// debugText.text = camera.focus.x + '';
		// debugText.text = Math.floor(Timer.fps()) + ' FPS \n\n';
		// debugText.text += Entity.ALL.length + ' entities \n\n';
		// debugText.text += Entity.AllActive().length + ' entities \n\n';

		// for(p in Process.getSortedProfilerTimes().filter(set -> return set.value >= 1.0)) {
		// 	debugText.text += p.key + ': ' + p.value + '\n';
		// }
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

		var tx = (camera.pxWidth / 2) - 160;
		var ty = 20;
		var ch = 40;
		var chh = 20;
		var cw = 20;
		var cwh = 10;
		var sw = cw + 10;

		var distVec = new Vector2(world.target.x - world.player.centerX, world.target.y - world.player.centerY);
		var dist = Math.floor(distVec.length / 50) + '';

		var iter = new StringIterator(dist);

		for(i in 0...dist.length) {
			var l = dist.charAt(i);

			if(l == '0') {
				g.moveTo(tx + cw, ty);
				g.lineTo(tx, ty);
				g.lineTo(tx, ty + ch);
				g.lineTo(tx + cw, ty + ch);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx, ty + ch);
				tx += sw;
			}
			else if(l == '1') {
				g.moveTo(tx, ty);
				g.lineTo(tx + cwh, ty);
				g.lineTo(tx + cwh, ty + ch);
				g.moveTo(tx, ty + ch);
				g.lineTo(tx + cw, ty + ch);
				tx += sw;
			}
			else if(l == '2') {
				g.moveTo(tx, ty);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx + cw, ty + chh);
				g.lineTo(tx, ty + chh);
				g.lineTo(tx, ty + ch);
				g.lineTo(tx + cw, ty + ch);
				tx += sw;
			}
			else if(l == '3') {
				g.moveTo(tx, ty);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx + cw, ty + ch);
				g.lineTo(tx, ty + ch);
				g.moveTo(tx + cw, ty + chh);
				g.lineTo(tx, ty + chh);
				tx += sw;
			}
			else if(l == '4') {
				g.moveTo(tx, ty);
				g.lineTo(tx, ty + chh);
				g.lineTo(tx + cw, ty + chh);
				g.moveTo(tx + cw, ty);
				g.lineTo(tx + cw, ty + ch);
				tx += sw;
			}
			else if(l == '5') {
				g.moveTo(tx + cw, ty);
				g.lineTo(tx, ty);
				g.lineTo(tx, ty + chh);
				g.lineTo(tx + cw, ty + chh);
				g.lineTo(tx + cw, ty + ch);
				g.lineTo(tx, ty + ch);
				tx += sw;
			}
			else if(l == '6') {
				g.moveTo(tx + cw, ty);
				g.lineTo(tx, ty);
				g.lineTo(tx, ty + ch);
				g.lineTo(tx + cw, ty + ch);
				g.lineTo(tx + cw, ty + chh);
				g.lineTo(tx, ty + chh);
				tx += sw;
			}
			else if(l == '7') {
				g.moveTo(tx, ty);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx, ty + ch);
				tx += sw;
			}
			else if(l == '8') {
				g.moveTo(tx, ty);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx + cw, ty + ch);
				g.lineTo(tx, ty + ch);
				g.lineTo(tx, ty);
				g.moveTo(tx, ty + chh);
				g.lineTo(tx + cw, ty + chh);
				tx += sw;
			}
			else if(l == '9') {
				g.moveTo(tx + cw, ty + ch);
				g.lineTo(tx + cw, ty);
				g.lineTo(tx, ty);
				g.lineTo(tx, ty + chh);
				g.lineTo(tx + cw, ty + chh);
				tx += sw;
			}

		}

		tx += sw;

		// T
		g.moveTo(tx, ty);
		g.lineTo(tx + cw, ty);
		g.moveTo(tx + cwh, ty);
		g.lineTo(tx + cwh, ty + ch);
		tx += sw;

		// O
		g.drawEllipse(tx + cwh, ty + chh, cwh, chh);
		tx += sw;

		// SPACE
		tx += sw;

		// T
		g.moveTo(tx, ty);
		g.lineTo(tx + cw, ty);
		g.moveTo(tx + cwh, ty);
		g.lineTo(tx + cwh, ty + ch);
		tx += sw;

		// A
		g.moveTo(tx, ty + ch);
		g.lineTo(tx, ty + chh);
		g.lineTo(tx + cwh, ty);
		g.lineTo(tx + cw, ty + chh);
		g.lineTo(tx + cw, ty + ch);
		g.moveTo(tx, ty + chh);
		g.lineTo(tx + cw, ty + chh);
		tx += sw;

		// R
		g.moveTo(tx, ty + ch);
		g.lineTo(tx, ty);
		g.lineTo(tx + cw, ty);
		g.lineTo(tx + cw, ty + chh);
		g.lineTo(tx, ty + chh);
		g.lineTo(tx + cw, ty + ch);
		tx += sw;

		// G
		g.moveTo(tx + cw, ty);
		g.lineTo(tx, ty);
		g.lineTo(tx, ty + ch);
		g.lineTo(tx + cw, ty + ch);
		g.lineTo(tx + cw, ty + chh);
		g.lineTo(tx + cwh, ty + chh);
		tx += sw;

		// E
		g.moveTo(tx + cw, ty);
		g.lineTo(tx, ty);
		g.lineTo(tx, ty + ch);
		g.lineTo(tx + cw, ty + ch);
		g.moveTo(tx, ty + chh);
		g.lineTo(tx + cwh, ty + chh);
		tx += sw;

		// T
		g.moveTo(tx, ty);
		g.lineTo(tx + cw, ty);
		g.moveTo(tx + cwh, ty);
		g.lineTo(tx + cwh, ty + ch);
		tx += sw;
	}
}
