package proc;

import h2d.Sprite;
import dn.heaps.HParticle;
import dn.Tweenie;

class Fx extends Process {
	var game(get,never) : Game; inline function get_game() return Game.inst;

	public function new() {
		super(Game.inst);
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();
	}
}