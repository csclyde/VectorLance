package proc;

import en.Player;

class Background extends Process {
	public var g : h2d.Graphics;
	public var bgTile: h2d.Tile;

	public function new() {
		super(game);

		delayer.addF('create_stuff', () -> {
			g = new h2d.Graphics();
			world.root.add(g, Const.BACKGROUND_OBJECTS);
	
			bgTile = hxd.Res.space.toTile();
		}, 1 );

		reset();
	}

	override function reset() {
		
	}

	override function update() {
		if(g == null) return;
		
		g.clear();

		g.tileWrap = true;
		g.beginTileFill(0, 0, 1, 1, bgTile);        
        g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 
		g.endFill();
	}
}