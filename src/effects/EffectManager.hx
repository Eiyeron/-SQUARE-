package effects;
import luxe.Entity;
import luxe.Component;
import luxe.Color;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import luxe.tween.Actuate;

import components.TimedBonus;

class EffectManager extends Entity{

	private var effects : Array<Component>;
	private var countdownSprite        : Sprite;
	private var text                   : MenuText;

	public function new() {
		super();
		countdownSprite = new Sprite({
			size  : new Vector( Luxe.screen.w / 3, 30),
			pos   : new Vector(Luxe.screen.mid.x, Luxe.screen.h / 4),
			color : new Color().rgb(0x333333),
			scale : new Vector(0, 1),
			depth : -0.5
			});
		countdownSprite.color.a = 1;
		countdownSprite.parent = this;
		text = new MenuText(
			new Vector(Luxe.screen.mid.x, Luxe.screen.h / 4 + 10),
			"",
			Luxe.resources.find_font('open_sans'),
			32, 0x333333
			);
		text.color.a = 1;
		text.parent = this;
		effects = new Array();
		effects.push(new SlowMotion());
		for(comp in effects)
			add( comp );
	}

	public function getEffect( name: String):TimedBonus {
		return cast(components.get(name), TimedBonus);
	}

	public function start(name : String) {
		
		var effect:TimedBonus = getEffect(name);
		effect.start();

		text.text = effect.text;

		countdownSprite.scale.x = 1;
		Actuate.tween(countdownSprite.scale, effect.countdownStartingValue, {x : 0})
			.onComplete(end, [name]);
		Actuate.tween(countdownSprite.color, 0.5, {a : 1});

		text.fadeIn(text.pos, 0.5);

	}


	public function end(name:String) {
		var effect:TimedBonus = getEffect(name);
		effect.end();
		Actuate.tween(countdownSprite.color, 0.5, {a : 0});
		text.fadeOut(0.5);
	}

	public function endAll() {
		for(comp in effects)
			end(comp.name);
	}
}