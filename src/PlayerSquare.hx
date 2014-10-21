import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.collision.shapes.Polygon;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;
import luxe.collision.ShapeDrawerLuxe;

import components.Hitbox;

class PlayerSquare extends luxe.Sprite {
	private var _scaleBig     : Float;
	private var _scaleTiny    : Float;
	private var _scaleDelta   : Float;
	private var _drawer       : ShapeDrawerLuxe;

	public function new( pos:Vector, scale:Float, scaleMax:Float ) {
		super({
			pos: pos,
			color: new Color().rgb(0xD64937),
			scale: new Vector(scale, scale),
			size : new Vector(32, 32)
			});
		this.pos = pos;
		this.scale = new Vector(scale, scale);

		this._scaleTiny = scale;
		this._scaleBig = scaleMax;
		this._scaleDelta = scaleMax - scale;

		add(new Hitbox("hitbox", size));

		_drawer = new ShapeDrawerLuxe();
		this.active = true;
	}


	public function animBigger( delay:Int = 0 ) {
		//if(this._animationDone == false) return;
		Actuate.tween( this.scale, 1 - (this.scale.x - this._scaleTiny)/this._scaleDelta, {x:this._scaleBig, y:this._scaleBig} )
        .ease( luxe.tween.easing.Elastic.easeOut )
        .delay(delay);
	}

	public function animSmaller( delay:Int = 0 ) {
		//if(this._animationDone == false) return;
        Actuate.tween(this.scale, (this.scale.x - this._scaleTiny)/this._scaleDelta, {x:this._scaleTiny, y:this._scaleTiny})
        .ease(luxe.tween.easing.Elastic.easeIn)
        .delay(delay);
	}
}
