package eng;

class CustomGraphics extends h2d.Graphics {
    public function new() {
        super();
    }

    public override function drawCircle( cx : Float, cy : Float, radius : Float, nsegments = 0 ) {
		flush();
        
		if( nsegments == 0 )
			nsegments = Math.ceil(Math.abs(radius * 3.14 * 2 / 4));
		if( nsegments < 3 ) nsegments = 3;

		var angle = Math.PI * 2 / nsegments;
		for( i in 0...nsegments + 1 ) {
			var a = i * angle;
			lineTo(cx + Math.cos(a) * radius, cy + Math.sin(a) * radius);
		}

		flush();
	}

    public override function addVertex( x : Float, y : Float, r : Float, g : Float, b : Float, a : Float, u : Float = 0., v : Float = 0. ) {

		if( x < xMin ) xMin = x;
		if( y < yMin ) yMin = y;
		if( x > xMax ) xMax = x;
		if( y > yMax ) yMax = y;

		if( doFill )
			content.add(x, y, u, v, r, g, b, a);
        
		var gp = new h2d.Graphics.GPoint();
		gp.load(x, y, lineR, lineG, lineB, lineA);
		tmpPoints.push(gp);
	}
}