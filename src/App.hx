class App extends hxd.App {
	public static var inst : App;

	static function main() {
		new App();
	}

	override function init() {
		inst = this;
		hxd.Res.initEmbed();

		// CastleDB hot reloading
		#if debug
        hxd.res.Resource.LIVE_UPDATE = true;
        hxd.Res.data.watch(function() {
            delayer.cancelById("cdb");
            delayer.addS("cdb", function() {
				// Only reload actual updated file from disk after a short delay, to avoid reading a file being written
            	Data.load(hxd.Res.data.entry.getBytes().toString());
            	if(Game.inst!=null)
                    Game.inst.onCdbReload();
            }, 0.2);
        });
		#end

		// Assets & data init
		hxd.snd.Manager.get(); // force sound manager init on startup instead of first sound play
		Assets.init(); // init assets
		new ui.Console(Assets.fontTiny, s2d); // init debug console
		Data.load(hxd.Res.data.entry.getText()); // read castleDB json

		// Start with 1 frame delay, to avoid 1st frame freezing from the game perspective
		hxd.Timer.wantedFPS = Const.FPS;
		hxd.Timer.skip();
		
		new Game(s2d);
		onResize();
	}

	override function onResize() {
		super.onResize();
		Process.resizeAll();
	}

	override function update(deltaTime:Float) {
		super.update(deltaTime);

		dn.heaps.Controller.beforeUpdate();

		var currentTmod = hxd.Timer.tmod;
		Process.updateAll(currentTmod);
	}
}
