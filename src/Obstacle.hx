import luxe.Color;
import luxe.Sprite;
import luxe.Vector;
import luxe.Events;
import luxe.utils.Maths;

import components.MovingEntity;
import components.Hitbox;

class Obstacle extends luxe.Sprite {
	public static inline var OFFSET:Int = 40;

	public function new() {
		super({
			color: new Color().rgb(0xDEDEDE),
			size : new Vector(32, 32),
			pos  : new Vector(-OFFSET, -OFFSET)
			});
		active = false;
		add(new MovingEntity({name:"move"}));
		add(new Hitbox("hitbox", size));
		active = true;
	}

}