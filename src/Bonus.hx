import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Events;
import luxe.utils.Maths;

import components.MovingEntity;
import components.Hitbox;

class Bonus extends luxe.Sprite {
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
		active = true;
		this.rotation_z = Maths.random_float(0, 360);
	}

	public override function update(dt:Float) {
		this.rotation_z += 20*dt;
	}
}