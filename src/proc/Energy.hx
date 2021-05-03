package proc;

import en.Player;

class Energy extends Process {

	var currentEnergy = 50.0;
	var maxEnergy = 100.0;

	public function new() {
		super(game);
	}

	public function getEnergy() {
		return currentEnergy;
	}

	public function getNormalizedEnergy() {
		try {
			return (currentEnergy - world.player.charge) / maxEnergy;
		} catch(e) {
			return (currentEnergy) / maxEnergy;
		}
	}

	public function getMaxEnergy() {
		return maxEnergy;
	}

	public function getNormalizedMaxEnergy() {
		return maxEnergy / 100;
	}

	public function addEnergy(amount:Float) {
		currentEnergy += amount;
		if(currentEnergy > maxEnergy) {
			currentEnergy = maxEnergy;
		}
	}

	public function removeEnergy(amount:Float) {
		currentEnergy -= amount;
	}

	override public function onDispose() {
		super.onDispose();
	}

	override function update() {
		super.update();
	}
}