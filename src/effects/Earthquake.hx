package effects;

import luxe.Component;
import luxe.tween.Actuate;

import components.TimedBonus;

class Earthquake extends TimedBonus {

	public function new() {
		super({name:"shake", countdownTime:5});
		text = "Earthquake";
	}

	public override function start() {
		super.start();
        Actuate.update(Luxe.camera.shake, 10, [15], [0]);
	}

}
