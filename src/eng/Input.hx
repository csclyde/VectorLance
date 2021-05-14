package eng;

class Input extends Process {
	public var ca : dn.heaps.Controller.ControllerAccess;
	public var controller : dn.heaps.Controller;

	public var mouseX : Float;
	public var mouseY : Float;
	public var mouseWorldX : Float;
	public var mouseWorldY : Float;

	public function new() {
		super(game);

		controller = new dn.heaps.Controller(App.inst.s2d);
		controller.bind(AXIS_LEFT_X_NEG, K.LEFT, K.Q, K.A);
		controller.bind(AXIS_LEFT_X_POS, K.RIGHT, K.D);
		controller.bind(X, K.SPACE, K.F, K.E);
		controller.bind(A, K.UP, K.Z, K.W);
		controller.bind(B, K.ENTER, K.NUMPAD_ENTER);
		controller.bind(SELECT, K.R);
		controller.bind(START, K.N);

		ca = controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);

		hxd.Window.getInstance().addEventTarget(onEvent);
	}

	function onEvent(event : hxd.Event) {
		if(event.kind == ERelease && event.button == 0) {
			events.send('launch_vector', {});
		}
		else if(event.kind == EPush && event.button == 0) {
			events.send('charge_vector', {});
		}
	}

	override function preUpdate() {
		super.preUpdate();

		mouseX = App.inst.s2d.mouseX;
		mouseY = App.inst.s2d.mouseY;

		mouseWorldX = mouseX + camera.focus.x - camera.pxWidth * 0.5;
		mouseWorldY = mouseY + camera.focus.y  - camera.pxHeight * 0.5;
	}

	override function postUpdate() {
		super.postUpdate();
	}


	override function update() {
		super.update();

		if(input.ca.isKeyboardPressed(K.ESCAPE)) {
			events.send('exit_game');
		}

		if(input.ca.isKeyboardPressed(K.R)) {
			events.send('restart_game');
		}
	}

}