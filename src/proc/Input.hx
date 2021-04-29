package proc;

class Input extends dn.Process {
	var camera(get,never) : Camera; inline function get_camera() return Game.inst.camera;

	public var ca : dn.heaps.Controller.ControllerAccess;

	public var mouseX : Float;
	public var mouseY : Float;
	public var mouseWorldX : Float;
	public var mouseWorldY : Float;

	public function new() {
		super(Game.inst);

		ca = Main.inst.controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);
	}

	override function preUpdate() {
		super.preUpdate();

		mouseX = Boot.inst.s2d.mouseX;
		mouseY = Boot.inst.s2d.mouseY;

		mouseWorldX = mouseX + camera.focus.x - camera.pxWidth * 0.5;
		mouseWorldY = mouseY + camera.focus.y  - camera.pxHeight * 0.5;
	}

	override function postUpdate() {
		super.postUpdate();
	}


	override function update() {
		super.update();
	}

}