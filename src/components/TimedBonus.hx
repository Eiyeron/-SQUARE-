package components;

import luxe.Component;

typedef TimedBonusTypedArgs = {
	name          : String,
	countdownTime : Float
}

class TimedBonus extends Component {

	public var text:String;
	public var countdownStartingValue : Float;
	public function new(data:TimedBonusTypedArgs) {
		super({name : data.name});
		countdownStartingValue = data.countdownTime;
	}

	public function start() {
	}

	public function end() {
	}
}