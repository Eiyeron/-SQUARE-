import luxe.Color;
import luxe.Text;
import luxe.Vector;
import luxe.tween.Actuate;

import phoenix.BitmapFont;

class MenuText extends luxe.Text {

	private var _originalPos : Vector;
	public override function new(pos:Vector, text:String, font:BitmapFont, size:Int = 20,  color:Int = 0xF9F9F9, align:TextAlign = null) {
		if( align == null)
		align = TextAlign.center;
		super({
			pos:pos,
			text:text,
			font:font,
			color: new Color().rgb(color),
			size: size,
			depth : 3,
			align : align,
			align_vertical : TextAlign.center

			});
		_originalPos = new Vector();
		_originalPos.copy_from(pos);
	}

	public function fadeIn(newPos:Vector, length:Float = 0.5, delay:Float=0, onComplete:Dynamic = null) {
		this.color.a = 0;
		pos.copy_from(_originalPos);
		Actuate.tween(this.color, length, {a:1}).delay(delay);
		if( onComplete != null)
		Actuate.tween(this.pos, length, {x:newPos.x, y:newPos.y}).delay(delay).onComplete(onComplete);
		else
		Actuate.tween(this.pos, length, {x:newPos.x, y:newPos.y}).delay(delay);

	}

	public function fadeOut(length:Float = 0.5, delay:Float = 0, onComplete:Dynamic = null) {
		Actuate.tween(this.color, length, {a:0}).delay(delay);
		if( onComplete != null)
		Actuate.tween(this.pos, length, {x:_originalPos.x, y:_originalPos.y}).delay(delay).onComplete(onComplete);
		else
		Actuate.tween(this.pos, length, {x:_originalPos.x, y:_originalPos.y}).delay(delay);

	}

}