class Boot extends hxd.App {
	public static var ME : Boot;

	static function main() {
		new Boot();
	}

	override function init() {
		ME = this;
		new Main(s2d);
		onResize();
	}

	override function onResize() {
		super.onResize();
		dn.Process.resizeAll();
	}

	override function update(deltaTime:Float) {
		super.update(deltaTime);

		dn.heaps.Controller.beforeUpdate();

		var currentTmod = hxd.Timer.tmod;
		dn.Process.updateAll(currentTmod);
	}
}
