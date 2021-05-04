package eng;

import h2d.Sprite;
import dn.heaps.HParticle;
import dn.Tweenie;

class Fx extends Process {

	public var g : h2d.Graphics;

	public function new() {
		super(game);

		createRootInLayers(world.root, Const.FOREGROUND_EFFECTS);

		g = new h2d.Graphics();
		root.add(g, Const.BACKGROUND_OBJECTS);
	}

	public function shatterOrb(radius, color, thickness) {

	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();

		// g.beginFill(0xFFFFFF);
		// g.drawRect(0, 0, 100, 100);
		// g.endFill();
	}
}