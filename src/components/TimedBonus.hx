package components;

import luxe.Component;

typedef TimedBonusTypedArgs = {
	name          : String,
	countdownTime : Float
}

class TimedBonus extends Component {

	public var text:String;
	public var countdownStartingValue : Float;
	private var _isRunning:Bool;

	public function new(data:TimedBonusTypedArgs) {
		super({name : data.name});
		countdownStartingValue = data.countdownTime;
	}

	public function isRunning():Bool {
		return _isRunning;
	}

	public function start() {
		_isRunning = true;
	}

	public function end() {
		_isRunning = false;
	}
}