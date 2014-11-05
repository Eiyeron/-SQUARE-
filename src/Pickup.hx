import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.utils.Maths;

import components.MovingEntity;
import components.Hitbox;
import components.RotatingEntity;

class Pickup extends luxe.Sprite {
	public static inline var OFFSET:Int = 40;

	public function new() {
		super({
			color: new Color().rgb(0xD64937),
			size : new Vector(24, 24),
			pos  : new Vector(-OFFSET, -OFFSET)
			});

		active = false;
		add(new MovingEntity({name:"move"}));
		add(new Hitbox("hitbox", size));
		add(new RotatingEntity("rotation", 20));

		this.rotation_z = Maths.random_float(0, 360);
		active = true;
	}
}