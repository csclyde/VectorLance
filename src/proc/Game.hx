package proc;

import dn.Process;

class Game extends Process {
	public static var inst : Game;

	public var input: Input;
	public var fx : Fx;
	public var camera : Camera;
	public var view_layers : h2d.Layers;
	public var level : Level;
	public var hud : ui.Hud;
	public var e : EventRouter;
	public var g : h2d.Graphics;

	public var player : en.Player;

	public var bgTile: h2d.Tile;

	public function new() {
		super(Main.inst);
		inst = this;
		
		createRootInLayers(Main.inst.root, Const.BACKGROUND_OBJECTS);

		view_layers = new h2d.Layers();
		root.add(view_layers, Const.BACKGROUND_OBJECTS);
		view_layers.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

		input = new Input();
		camera = new Camera();
		level = new Level();
		fx = new Fx();
		hud = new ui.Hud();
		e = new EventRouter();

		g = new h2d.Graphics();
		Game.inst.view_layers.add(g, Const.MIDGROUND_OBJECTS);

		player = new en.Player(0, 0);

		camera.trackEntity(player);

		bgTile = hxd.Res.space.toTile();

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

		g.clear();

		// g.beginFill(0x000000);
		// g.drawRect(camera.focus.x - camera.pxWidth * 0.5, camera.focus.y - camera.pxHeight * 0.5, camera.pxWidth, camera.pxHeight);

		g.tileWrap = true;
		g.beginTileFill(camera.levelToGlobalX(camera.left), camera.levelToGlobalY(camera.top), 1, 1, bgTile);        
        g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 

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
			if(input.ca.isKeyboardPressed(K.ESCAPE))
				if(!cd.hasSetS("exitWarn",3))
					trace("Press ESCAPE again to exit.");
				else
					hxd.System.exit();
			#end

			// Restart
			if(input.ca.selectPressed())
				Main.inst.startGame();
		}
	}
}

