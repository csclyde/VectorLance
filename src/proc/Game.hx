package proc;

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

		root.filter = new h2d.filter.Bloom();

		energy = new Energy();
		
		Process.resizeAll();
		trace("Game is ready.");
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

		for(e in Entity.ALL) if(!e.destroyed) e.update();

		if(!ui.Modal.hasAny()) {
			// Exit
			if(input.ca.isKeyboardPressed(K.ESCAPE))
				if(!cd.hasSetS("exitWarn", 3))
					trace("Press ESCAPE again to exit.");
				else
					hxd.System.exit();
		}
	}
}

