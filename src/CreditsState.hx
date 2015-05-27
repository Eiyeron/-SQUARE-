import luxe.Events;
import luxe.Input;
import luxe.States;
import luxe.Text;
import luxe.Vector;
import luxe.tween.Actuate;

import phoenix.BitmapFont;

import io.LocalSave;

typedef CreditsStateTypedArgs = {
	name : String,
	machine: States,
	square : PlayerSquare

}

class CreditsState extends luxe.State {

	private var _font            : BitmapFont;
	private var _staff_objs       : Array<MenuText>;
	private var _staff_text       : Array<String>;
	private var _site_objs       : Array<MenuText>;
	private var _site_text       : Array<String>;
	private var _square          : PlayerSquare;

	private var ev:Events;


	public function new( data:CreditsStateTypedArgs ) {
		super({ name:data.name });
		machine = data.machine;
		_square = data.square;

		ev = new Events();
		ev.listen("back", back);

		_staff_text = ["Code by Eiyeron", "Music by Xorus"];
		_staff_objs = new Array<MenuText>();
		_site_text = ["geekbros.tk/retro-actif", "xorus.nerdbox.fr"];
		_site_objs = new Array<MenuText>();

		_font = Luxe.resources.font('assets/open_sans/open_sans.fnt');
		var i:Int = 0;
		for( line in _staff_text ) {
			var text_line = new MenuText(
				new Vector(Luxe.screen.w*4.7/6, 1 + 2*Luxe.screen.h/5 + Luxe.screen.h*i/8),
				line, _font, 30, 0xdedede
			);
			text_line.color.a = 0;
			_staff_objs.push(text_line);
			i++;
		}

		i=0;
		for( line in _site_text ) {
			var text_line = new MenuText(
				new Vector(Luxe.screen.w*1.7/6, 1 + 2*Luxe.screen.h/5 + Luxe.screen.h*i/8),
				line, _font, 30, 0xdedede
			);
			text_line.color.a = 0;
			_site_objs.push(text_line);
			i++;
		}


	}

	function back<T>( arg:T ) {
		machine.set("Menu");
	}

	override function init() {
	} //ready

	override function onenter<T>( _data:T) {
		Actuate.tween(_square.pos, 0.5, {x:Luxe.screen.mid.x*7/4., y:Luxe.screen.mid.y});

		var i:Int = 1;
		for( text_line in _staff_objs ) {
			text_line.fadeIn(
				new Vector(Luxe.screen.w*4.5/6, text_line.pos.y),
				0.5, 0.1*i
			);
			i++;
		}

		i = 1;
		for( text_line in _site_objs ) {
			text_line.fadeIn(
				new Vector(Luxe.screen.w*1.5/6, text_line.pos.y),
				0.5, 0.1*i
			);
			i++;
		}

	}

	override function onleave<T>( _data:T ) {
		var i:Int = 1;
		for( text_line in _staff_objs ) {
			text_line.fadeOut(
				0.5, 0.1*i
			);
			i++;
		}
		i = 1;
		for( text_line in _site_objs ) {
			text_line.fadeOut(
				0.5, 0.1*i
			);
			i++;
		}
	}

	override function update( delta:Float ) {
	}

	#if !web
	override function onkeydown( event:KeyEvent) {
		if( event.keycode == Key.escape || event.keycode == Key.key_c)
		back(null);
	}
	#end


	override function onmousedown( event:MouseEvent ) {
		trace("Mouse");
		back(null);
	}
}
