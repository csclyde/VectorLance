class Boot extends hxd.App {
	public static var inst : Boot;

	static function main() {
		new Boot();
	}

	override function init() {
		inst = this;
		new Main(s2d);
		onResize();
		trace(s2d.height);
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
