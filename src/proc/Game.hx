package proc;

class Game extends Process {
	public function new(s:h2d.Scene) {
		super();

		createRoot(s);

		// Engine settings
		engine.backgroundColor = 0x000000;
		engine.fullScreen = true;

		Process.resizeAll();

		events.subscribe('exit_game', (params:Dynamic) -> {
			hxd.System.exit();
		});

		events.subscribe('restart_game', (params:Dynamic) -> {
			reset();
		});

		audio.playMusic(hxd.Res.music.one);
	}

	public function onCdbReload() {}

	override function onResize() {
		super.onResize();
		root.setScale(Const.SCALE);
	}

	override function reset() {
		world.reset();
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

	public function beginProfile(name:String) {
		this.markProfilingStart(name);
	}

	public function endProfile(name:String) {
		this.markProfilingEnd(name);
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
	}
}
