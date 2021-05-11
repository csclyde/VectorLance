package proc;

import format.gif.Data.ColorTable;
import format.pdf.Crypt;
import h2d.filter.Glow;
import h2d.filter.Bloom;

class Game extends Process {

	public var energy: Energy;

	public function new(s:h2d.Scene) {
		super();

        createRoot(s);

		// Engine settings
		engine.backgroundColor = 0x000000;
        engine.fullScreen = true;

		energy = new Energy();
		
		Process.resizeAll();
	}

	public function onCdbReload() {}

	override function onResize() {
		super.onResize();
		root.setScale(Const.SCALE);
	}

	override function reset() {
		world.reset();
		energy.reset();
		hud.reset();
		fx.reset();
		camera.reset();
	}

	function gc() {
		if(Entity.GC == null || Entity.GC.length == 0) {
			return;
		}

		for(e in Entity.GC) {
			e.dispose();
		}
		
		Entity.GC = [];
	}

	override function onDispose() {
		super.onDispose();

		fx.destroy();
		for(e in Entity.ALL) {
			e.destroy();
		}

		gc();
	}

	override function preUpdate() {
		super.preUpdate();

		for(e in Entity.ALL) if(!e.destroyed) e.preUpdate();
	}

	override function postUpdate() {
		super.postUpdate();

		for(e in Entity.ALL) if(!e.destroyed) e.postUpdate();
		gc();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		for(e in Entity.ALL) if(!e.destroyed) e.fixedUpdate();
	}

	override function update() {
		super.update();

		for(e in Entity.AllActive()) {
			e.update();
		}

		if(!ui.Modal.hasAny()) {
			if(input.ca.isKeyboardPressed(K.ESCAPE))
				hxd.System.exit();
		}

		if(input.ca.isKeyboardPressed(K.NUMBER_1)) {
			App.inst.bloomFilter.power += 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_2)) {
			App.inst.bloomFilter.power -= 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_3)) {
			App.inst.bloomFilter.amount += 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_4)) {
			App.inst.bloomFilter.amount -= 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_5)) {
			App.inst.bloomFilter.radius += 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_6)) {
			App.inst.bloomFilter.radius -= 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_7)) {
			App.inst.bloomFilter.gain += 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_8)) {
			App.inst.bloomFilter.gain -= 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_9)) {
			App.inst.bloomFilter.quality += 0.1;
		}
		if(input.ca.isKeyboardPressed(K.NUMBER_0)) {
			App.inst.bloomFilter.quality -= 0.1;
		}
		
	}
}

