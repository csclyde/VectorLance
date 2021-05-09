package proc;

typedef Star = {
	x: Float,
	y: Float,
	z: Float,
}

class Background extends Process {
	public var g : h2d.Graphics;
	public var bgTile: h2d.Tile;
	public var stars: Array<Star>;

	public function new() {
		super(game);
		stars = [];

		delayer.addF('create_stuff', () -> {
			g = new h2d.Graphics();
			world.root.add(g, Const.BACKGROUND_OBJECTS);
			
			for(i in 0...600) {
				var newStar = {
					x: M.frandRange(0, camera.pxWidth),
					y: M.frandRange(0, camera.pxHeight),
					z: M.frandRange(0.2, 0.8),
				}

				newStar.x /= newStar.z;
				newStar.y /= newStar.z;

				stars.push(newStar);

			}
		}, 1 );

		reset();
	}

	override function reset() {
		
	}

	override function update() {
		if(g == null) return;

		g.tileWrap = true;

		g.clear();

		var offsetPosX:Float;
		var offsetPosY:Float;

		for(s in stars) {

			offsetPosX = camera.focus.x + (s.x - camera.focus.x) * s.z;
			offsetPosY = camera.focus.y + (s.y - camera.focus.y) * s.z;

			if (offsetPosX < camera.left) { s.x += camera.pxWidth/s.z; }
			if (offsetPosX > camera.right) { s.x -= camera.pxWidth/s.z; }
			if (offsetPosY < camera.top) { s.y += camera.pxHeight/s.z; }
			if (offsetPosY > camera.bottom) { s.y -= camera.pxHeight/s.z; }
				
			//g.lineStyle(1, 0xFFFFFF, M.frand());
			g.beginFill(0xFFFFFF, M.frand());
			g.drawCircle(offsetPosX, offsetPosY, 2);
		}
	}
}