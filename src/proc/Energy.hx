package proc;

class Energy extends Process {

	var currentEnergy = 50;
	var latentEnergy = 50;
	var maxEnergy = 100;

	public function new() {
		super(game);
	}

	public function getEnergy() {
		return currentEnergy;
	}

	public function getMaxEnergy() {
		return maxEnergy;
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();
	}
}