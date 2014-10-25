package components;

import luxe.Component;
import luxe.Vector;
import luxe.collision.Collision;
import luxe.collision.shapes.Polygon;

class Hitbox extends Component {
	
	public var boundingBox:Polygon;

	public function new(_name:String, size:Vector) {
		super({name:_name});
		boundingBox = Polygon.rectangle( 0, 0, size.x, size.y );
	}


	override function update(dt:Float) {
		boundingBox.x = entity.pos.x;
		boundingBox.y = entity.pos.y;
		boundingBox.position.copy_from(entity.pos);
		this.boundingBox.rotation = entity.rotation.z;
	}

	public static function testCollisionBetweenHitboxes(a:Hitbox, b:Hitbox):Bool {
		return Collision.test(a.boundingBox, b.boundingBox) != null;
	}


}