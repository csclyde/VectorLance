package en;

class Player extends Entity {
	var camera(get,never) : Camera; inline function get_camera() return Game.inst.camera;
	var input(get,never) : Input; inline function get_input() return Game.inst.input;

	public var g : h2d.Graphics;

	public function new(sx, sy) {
		super(sx, sy);

		// Some default rendering for our character
		g = new h2d.Graphics();
		Game.inst.view_layers.add(g, Const.MIDGROUND_OBJECTS);
	}

	public override function preUpdate() {}
    public override function postUpdate() {}
	public override function fixedUpdate() {}

    public override function update() {
		g.clear();

		g.beginFill(0xff0000);
		g.drawCircle(centerX, centerY, 16);

		g.lineStyle(1, 0xFF00FF);
		g.moveTo(centerX, centerY);
		g.lineTo(input.mouseWorldX, input.mouseWorldY);
	}
}
