import dn.Process;
import hxd.Key;

class Game extends Process {
	public static var inst : Game;

	public var ca : dn.heaps.Controller.ControllerAccess;
	public var fx : Fx;
	public var camera : Camera;
	public var view_layers : h2d.Layers;
	public var level : Level;
	public var hud : ui.Hud;
	public var e : EventRouter;

	public var player : en.Player;

	public function new() {
		super(Main.inst);
		inst = this;
		ca = Main.inst.controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);
		createRootInLayers(Main.inst.root, Const.BACKGROUND_OBJECTS);

		view_layers = new h2d.Layers();
		root.add(view_layers, Const.BACKGROUND_OBJECTS);
		view_layers.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

		camera = new Camera();
		level = new Level();
		fx = new Fx();
		hud = new ui.Hud();
		e = new EventRouter();

		player = new en.Player(100, 100);

		camera.trackEntity(player);

		Process.resizeAll();
		trace("Game is ready.");
	}

	public function onCdbReload() {}

	override function onResize() {
		super.onResize();
		view_layers.setScale(Const.SCALE);
	}

	function gc() {
		if(Entity.GC==null || Entity.GC.length==0) {
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

		if(!ui.Console.ME.isActive() && !ui.Modal.hasAny()) {
			#if hl
			// Exit
			if(ca.isKeyboardPressed(Key.ESCAPE))
				if(!cd.hasSetS("exitWarn",3))
					trace("Press ESCAPE again to exit.");
				else
					hxd.System.exit();
			#end

			// Restart
			if(ca.selectPressed())
				Main.inst.startGame();
		}
	}
}

