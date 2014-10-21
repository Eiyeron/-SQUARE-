package components;
import luxe.Component;
import luxe.Sprite;
import luxe.Vector;
import luxe.utils.Maths;
 
import phoenix.Quaternion;

class RotatingEntity extends Component {

	private var angularVelocity:Float;
	public function new(name:String, angularVelocity:Float = 0) {
		super({name:name});
		this.angularVelocity = angularVelocity;
	}

	override function update( dt:Float ) {
		cast(entity, Sprite).rotation_z += angularVelocity * dt;
	}

	public function setNewVelocity(angularVelocity:Float) {
		this.angularVelocity = angularVelocity;
	}

}
