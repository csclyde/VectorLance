class App extends hxd.App {
	public static var inst : App;

	public var game: Game;
	public var events: EventRouter;
	public var input: Input;
	public var fx: Fx;
	public var camera: Camera;
	public var hud: Hud;
	public var world: World;
	public var console: Console;
	public var audio: Audio;

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
		Assets.init(); // init assets
		Data.load(hxd.Res.data.entry.getText()); // read castleDB json
		
		// Start with 1 frame delay, to avoid 1st frame freezing from the game perspective
		hxd.Timer.wantedFPS = Const.FPS;
		hxd.Timer.skip();
		
		game = new Game(s2d);
		events = new EventRouter();
		input = new Input();
		camera = new Camera();
		hud = new Hud();
		console = new Console();
		audio = new Audio();
		world = new World();
		fx = new Fx();
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
