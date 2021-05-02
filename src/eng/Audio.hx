package eng;

class Audio extends Process {

	var snd: hxd.snd.Manager;

	public function new() {
		super(game);

		snd = hxd.snd.Manager.get(); // force sound manager init on startup instead of first sound play
	}

	override public function onDispose() {
		super.onDispose();

		snd.dispose();
	}

	override function update() {
		super.update();
	}
}