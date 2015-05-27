package effects;

import luxe.Component;

import components.TimedBonus;

class PointBonus extends TimedBonus {

	public function new() {
		super({name:"pointBonus", countdownTime:0});
		text = "Bonus Points";
	}

	public override function start() {
		super.start();
		Luxe.events.queue("bonusPoints");
	}

}
