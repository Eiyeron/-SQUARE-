package components;
import luxe.Component;
import luxe.Vector;
import luxe.utils.Maths;
import luxe.Events;

class MovingEntity extends Component {

	private var _direction     : Int;
	private var _ev            : Events;
	private var _running       : Bool;
	private var _velocity      : Vector;
	private var _velocity_temp : Vector;

	public var shouldBeReplaced : Bool;


	override function init() {
		this._running = false;
		this._velocity = new Vector();
		this._velocity_temp = new Vector();
		_ev = new Events();
		_ev.listen("start", start);
		replace(40, 240, 2, 4);
		shouldBeReplaced = false;
    } //init

    public function start<T>( data:T ) {
		//trace( "Run!" );
		_running = true;
	}

	override function update(dt:Float) {
		if( shouldBeReplaced ) {
			shouldBeReplaced = false;
			replace(40, 240, 2, 4);
		}
		if(!_running) return;
		_velocity_temp.copy_from(_velocity);
		_velocity_temp.multiplyScalar(dt);
		entity.pos.add(_velocity_temp);
		switch( _direction) {
			case 0:
			if(entity.pos.x > Luxe.screen.w + Obstacle.OFFSET) replace(_velocity.length + 5, _velocity.length + 10, 0, 1);
			case 1:
			if(entity.pos.x < -Obstacle.OFFSET) replace(_velocity.length + 5, _velocity.length + 10, 0, 1);
			case 2:
			if(entity.pos.y > Luxe.screen.h + Obstacle.OFFSET) replace(_velocity.length + 5, _velocity.length + 10, 0, 1);
			case 3:
			if(entity.pos.y < -Obstacle.OFFSET) replace(_velocity.length + 5, _velocity.length + 10, 0, 1);
		}
    	/*
        if(next_shake < Luxe.time) {
            Luxe.camera.shake(4);
            set_shake();
            }*/
    } //update

    public function replace(minSpeed:Float = 90, maxSpeed:Float = 240, minDelay:Float = 0, maxDelay:Float = 2) {
    	_running = false;
    	_direction = Maths.random_int(0, 3);
    	var speed:Float = Maths.random_float(minSpeed, maxSpeed);
    	var delay:Float = Maths.random_float(minDelay, maxDelay);
    	switch(_direction) {
    		case 0:
    		entity.pos.set_xy(-Obstacle.OFFSET,Maths.random_float(0, Luxe.screen.h));
    		_velocity.set_xy( speed, 0 );
    		case 1:
    		entity.pos.set_xy(Luxe.screen.w + Obstacle.OFFSET,Maths.random_float(0, Luxe.screen.h));
    		_velocity.set_xy( -speed, 0 );
    		case 2:
    		entity.pos.set_xy(Maths.random_float(0, Luxe.screen.w), -Obstacle.OFFSET);
    		_velocity.set_xy( 0, speed );
    		case 3:
    		entity.pos.set_xy(Maths.random_float(0, Luxe.screen.w), Luxe.screen.h + Obstacle.OFFSET);
    		_velocity.set_xy( 0, -speed );
    	}
    	_ev.schedule(delay, "start");
    }

}