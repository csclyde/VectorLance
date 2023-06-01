package eng;

class Emitter extends h2d.Particles {
	public function new() {
		super();
	}

	// override load to start everything off as disabled
	public override function load(o:Dynamic, ?resourcePath:String) {
		super.load(o, resourcePath);

		for(g in groups) {
			g.enable = false;
		}
	}

	// override the onEnd function to stop any emitters that dont loop
	public override dynamic function onEnd() {
		for(g in groups) {
			if(g.animationRepeat != 0) {
				g.rebuild();
			} else {
				g.enable = false;
			}
		}
	}

	public function play() {
		for(g in groups) {
			g.enable = true;
		}
	}

	public function stop() {
		for(g in groups) {
			g.enable = false;
		}
	}

	public function setCount(c:Int) {
		for(g in groups) {
			g.nparts = c;
		}
	}

	public function setAngle(a:Float) {
		for(g in groups) {
			g.emitAngle = a;
		}
	}
}
