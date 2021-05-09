package proc;

import hxmath.math.Vector2;
import en.Player;

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
	
			bgTile = hxd.Res.space.toTile();
			
			for(i in 0...600) {
				var newStar = {
					x: M.frandRange(0, camera.pxWidth),
					y: M.frandRange(0, camera.pxHeight),
					z: M.frand() * 2
				}
				stars.push(newStar);

			}
		}, 1 );

		reset();
	}

	override function reset() {
		
	}

	override function update() {
		if(g == null) return;

		// g.x = camera.left;
		// g.y = camera.top;
		g.tileWrap = true;

		g.clear();

		var offsetPosX:Float;
		var offsetPosY:Float;

		for(s in stars) {
			offsetPosX = (-1 * (s.x + camera.focus.x) % camera.pxWidth) * s.z;
			if(offsetPosX < 0) { offsetPosX += camera.pxWidth; }

			offsetPosY = (-1 * (s.y + camera.focus.y) % camera.pxHeight) * s.z;
			if(offsetPosY < 0) { offsetPosY += camera.pxHeight; }

			g.lineStyle(1, 0xFFFFFF, M.frand());
			g.drawCircle(offsetPosX + camera.left, (offsetPosY % camera.pxHeight) + camera.top, 1);
		}
		

		// g.tileWrap = true;
		// g.beginTileFill(0, 0, 1, 1, bgTile);        
        // g.drawRect(camera.left, camera.top, camera.pxWidth, camera.pxHeight); 
		// g.endFill();

	}
}