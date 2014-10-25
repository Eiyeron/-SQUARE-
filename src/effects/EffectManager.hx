package effects;

import luxe.Entity;
import luxe.Color;
import luxe.Sprite;
import luxe.Text;
import luxe.Vector;
import luxe.tween.Actuate;
import luxe.utils.Maths;

import components.TimedBonus;

class EffectManager extends Entity {

	private var _effects         : Array<TimedBonus>;
	private var _countdownSprite : Sprite;
	private var _text            : MenuText;

	public function new() {
		super();
		_countdownSprite = new Sprite({
			size  : new Vector( Luxe.screen.w / 3, 30),
			pos   : new Vector(Luxe.screen.mid.x, Luxe.screen.h / 4),
			color : new Color().rgb(0x333333),
			scale : new Vector(0, 1),
			depth : -0.5
			});
		_countdownSprite.color.a = 1;
		_countdownSprite.parent = this;

		_text = new MenuText(
			new Vector(Luxe.screen.mid.x, Luxe.screen.h / 4 + 20),
			"",
			Luxe.resources.find_font('open_sans'),
			32, 0x333333
			);
		_text.color.a = 1;
		_text.parent = this;

		_effects = new Array();
		_effects.push(new SlowMotion());
		_effects.push(new SpeedUp());
		for(comp in _effects)
			add( comp );
	}

	public function getEffect( name: String):TimedBonus {
		return cast(components.get(name), TimedBonus);
	}

	public function startRandom() {
		start(_effects[Maths.random_int(0, _effects.length - 1)].name);
	}

	public function start(name : String) {
		
		var effect:TimedBonus = getEffect(name);
		effect.start();

		_text.text = effect.text;

		_countdownSprite.scale.x = 1;
		Actuate.tween(_countdownSprite.scale, effect.countdownStartingValue, {x : 0})
			.onComplete(end, [name]);
		Actuate.tween(_countdownSprite.color, 0.5, {a : 1});

		_text.fadeIn(_text.pos, 0.5);

	}


	public function end(name:String = null) {
		Actuate.tween(_countdownSprite.color, 0.5, {a : 0});
		_text.fadeOut(0.5);
		if( name == null) return;
		var effect:TimedBonus = getEffect(name);
		effect.end();
	}

	public function endAll() {
		for(comp in _effects)
			if( comp.isRunning())
				comp.end();
		end();
	}
}