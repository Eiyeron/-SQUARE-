package effects;

import luxe.Component;
import luxe.tween.Actuate;

import components.TimedBonus;

class SpeedUp extends TimedBonus {

	public function new() {
		super({name:"speedup", countdownTime:5});
		text = "Speed Up";
	}

	public override function start() {
		super.start();
		Actuate.tween(Luxe, 0.5, {timescale: 2});
	}

	public override function end() {
		super.end();
		Actuate.tween(Luxe, 0.5, {timescale: 1});	
	}
}