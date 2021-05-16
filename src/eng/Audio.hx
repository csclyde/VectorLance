package eng;

class Audio extends Process {

	var snd: hxd.snd.Manager;

	public function new() {
		super(game);

		var stuff = hxd.Res.sounds.charge;
		snd = hxd.snd.Manager.get(); // force sound manager init on startup instead of first sound play
	}

	override public function onDispose() {
		super.onDispose();

		snd.dispose();
	}

	override function update() {
		super.update();
	}

	public function playSound(sound:hxd.res.Sound) {
		sound.play();
	}

	public function playSoundCd(sound:hxd.res.Sound, t: Int) {
		if(!cd.has('snd_wait')) {
			hxd.Res.sounds.energy.play();
			cd.setMs('snd_wait', t);
		}
	}
}