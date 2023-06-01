package proc;

class Energy extends Process {
	var currentEnergy:Float;
	var maxEnergy:Float;

	public function new() {
		super(game);

		reset();
	}

	public function getEnergy() {
		return currentEnergy;
	}

	public function getNormalizedEnergy() {
		return currentEnergy / maxEnergy;
	}

	public function getMaxEnergy() {
		return maxEnergy;
	}

	public function getNormalizedMaxEnergy() {
		return maxEnergy / 100;
	}

	public function addEnergy(amount:Float) {
		if(amount > 0 && currentEnergy <= 0) {
			currentEnergy = 0;
		}

		currentEnergy += amount;
		if(currentEnergy > maxEnergy) {
			currentEnergy = maxEnergy;
		}
	}

	public function removeEnergy(amount:Float) {
		currentEnergy -= amount;
	}

	override function reset() {
		currentEnergy = 100.0;
		maxEnergy = 100.0;
	}
}
