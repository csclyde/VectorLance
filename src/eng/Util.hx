package eng;

class Util {
    public function new() { }

    public function gauss(x:Float, height:Float, pos:Float, width:Float) {
        return height * Math.exp(-1 * (Math.pow(x - pos, 2) / (2 * Math.pow(width, 2))));
    }

}