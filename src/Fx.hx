import h2d.Sprite;
import dn.heaps.HParticle;
import dn.Tweenie;


class Fx extends dn.Process {
	var game(get,never) : Game; inline function get_game() return Game.ME;

	public function new() {
		super(Game.ME);
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();
	}
}