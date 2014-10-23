package effects;

import luxe.tween.Actuate;
import luxe.Component;
import components.TimedBonus;

class SlowMotion extends TimedBonus {

	public function new() {
		super({name:"slowmotion", countdownTime:5});
		text = "Slow motion";
	}

	public override function start() {
		trace("begin of slowmo");
		super.start();
		Actuate.tween(Luxe, 0.5, {timescale: 0.5});
	}

	public override function end() {
		trace("end of slowmo");
		super.end();
		Actuate.tween(Luxe, 0.5, {timescale: 1});	
	}
}