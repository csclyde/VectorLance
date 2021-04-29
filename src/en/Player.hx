package en;

class Player extends Entity {
	public function new(x,y) {
		super(x,y);

		// Some default rendering for our character
		var g = new h2d.Graphics(spr);
		g.beginFill(0xff0000);
		g.drawRect(0,0,16,16);

		Game.ME.view_layers.add(g, Const.DP_MAIN);
	}
}
