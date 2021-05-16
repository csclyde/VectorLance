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

	public function playSound(sound:hxd.res.Sound, ?loop:Bool = false) {
		sound.play(loop);
	}

	public function stopSound(sound:hxd.res.Sound) {
		sound.stop();
	}

	public function playSoundCd(sound:hxd.res.Sound, t: Int) {
		if(!cd.has('snd_wait')) {
			playSound(sound);
			cd.setMs('snd_wait', t);
		}
	}

	public function playMusic(music:hxd.res.Sound, ?loop:Bool = true) {
		music.play(loop);
	}
}