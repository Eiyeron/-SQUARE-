package components;
import luxe.Component;
import luxe.Vector;
import luxe.utils.Maths;
import luxe.Events;

class MovingEntity extends Component {

	private var velocity:Vector;
	private var velocity_temp:Vector;
	private var direction:Int;
	private var running:Bool;
	private var ev:Events;
	public var shouldBeReplaced:Bool;


	override function init() {
		this.running = false;
		this.velocity = new Vector();
		this.velocity_temp = new Vector();
		ev = new Events();
		ev.listen("start", start);
		replace(40, 240, 2, 4);
		shouldBeReplaced = false;
    } //init

    public function start<T>( data:T ) {
		//trace( "Run!" );
		running = true;
	}

	override function update(dt:Float) {
		if( shouldBeReplaced ) {
			shouldBeReplaced = false;
			replace(40, 240, 2, 4);
		}
		if(!running) return;
		velocity_temp.copy_from(velocity);
		velocity_temp.multiplyScalar(dt);
		entity.pos.add(velocity_temp);
		switch( direction) {
			case 0:
			if(entity.pos.x > Luxe.screen.w + Obstacle.OFFSET) replace(velocity.length + 5, velocity.length + 10, 0, 1);
			case 1:
			if(entity.pos.x < -Obstacle.OFFSET) replace(velocity.length + 5, velocity.length + 10, 0, 1);
			case 2:
			if(entity.pos.y > Luxe.screen.h + Obstacle.OFFSET) replace(velocity.length + 5, velocity.length + 10, 0, 1);
			case 3:
			if(entity.pos.y < -Obstacle.OFFSET) replace(velocity.length + 5, velocity.length + 10, 0, 1);
		}
    	/*
        if(next_shake < Luxe.time) {
            Luxe.camera.shake(4);
            set_shake();
            }*/
    } //update

    public function replace(minSpeed:Float = 90, maxSpeed:Float = 240, minDelay:Float = 0, maxDelay:Float = 2) {
    	running = false;
    	direction = Maths.random_int(0, 3);
    	var speed:Float = Maths.random_float(minSpeed, maxSpeed);
    	var delay:Float = Maths.random_float(minDelay, maxDelay);
    	switch(direction) {
    		case 0:
    		entity.pos.set_xy(-Obstacle.OFFSET,Maths.random_float(0, Luxe.screen.h));
    		velocity.set_xy( speed, 0 );
    		case 1:
    		entity.pos.set_xy(Luxe.screen.w + Obstacle.OFFSET,Maths.random_float(0, Luxe.screen.h));
    		velocity.set_xy( -speed, 0 );
    		case 2:
    		entity.pos.set_xy(Maths.random_float(0, Luxe.screen.w), -Obstacle.OFFSET);
    		velocity.set_xy( 0, speed );
    		case 3:
    		entity.pos.set_xy(Maths.random_float(0, Luxe.screen.w), Luxe.screen.h + Obstacle.OFFSET);
    		velocity.set_xy( 0, -speed );
    	}
    	ev.schedule(delay, "start");
    }

}