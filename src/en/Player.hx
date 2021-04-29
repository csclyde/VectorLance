package en;

class Player extends Entity {
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
		var mouseX = Boot.inst.s2d.mouseX;
		var mouseY = Boot.inst.s2d.mouseY;

		g.clear();
		
		g.beginFill(0xff0000);
		g.drawRect(centerX, centerY, 16, 16);

		g.lineStyle(1, 0xFF00FF);
		g.moveTo(centerX, centerY);
		g.lineTo(mouseX, mouseY);
	}
}
