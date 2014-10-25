import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.States;
import luxe.tween.Actuate;
import luxe.Input;
import luxe.Events;
import phoenix.BitmapFont;

import io.LocalSave;

typedef MenuStateTypedArgs = {
	name : String,
	machine: States,
	square : PlayerSquare

}

class MenuState extends luxe.State {

	private var _font            : BitmapFont;
	private var _g               : GameState;
	private var _highscore       : MenuText;
	private var _highscoreString : String;	
	private var _localStrg       : LocalSave;
	private var _menu_objs       : Array<MenuText>;
	private var _menu_text       : Array<String>;
	private var _square          : PlayerSquare;
	private var _title           : MenuText;


	private var ev:Events;
	public var readyPlay: Bool;


	public function new( data:MenuStateTypedArgs ) {
		super({ name:data.name });
		machine = data.machine;
		_square = data.square;
		ev = new Events();
		ev.listen("ready", readyToPlay);
		_localStrg = new LocalSave();

	}

	override function init() {
		trace("begin init");
		_menu_text = ["Click", "to", "Play", "[By Eiyeron]"];
		_menu_objs = new Array<MenuText>();
		_font = Luxe.resources.find_font('open_sans');

		_title = new MenuText(
			new Vector(Luxe.screen.w*4.7/6, Luxe.screen.h/5),
			'[SQUARE]', _font, 40, 0xdedede
			);
		_title.color.a = 0;

		var i:Int = 0;
		for( line in _menu_text ) {
			var text_line = new MenuText(
				new Vector(Luxe.screen.w*4.7/6, 2*Luxe.screen.h/5 + Luxe.screen.h*i/8),
				line, _font, 30, 0xdedede
				);
			text_line.color.a = 0;
			_menu_objs.push(text_line);
			i++;
		}
		_highscoreString = "Highscore unsupported here";
		_highscore = new MenuText(new Vector(-Luxe.screen.w/6,0), 
			_highscoreString,
			_font,
			24,
			0xdedede,
			TextAlign.left);
		_highscore.color.a = 0;

		_g = new GameState({name:'Game', square:_square});
		machine.add( _g );
		trace("end of init");
	}

	function readyToPlay<T>( _data:T ) {
		readyPlay = true;
	}

	override function onenter<T>( _data:T ) {
		trace("begin onenter");
		readyPlay = false;
		Luxe.timescale = 1;


		Actuate.tween(_square.pos, 0.5, {x:Luxe.screen.mid.x/4., y:Luxe.screen.mid.y});
		_title.fadeIn(
			new Vector(Luxe.screen.w*4.5/6, _title.pos.y),
			0.5, 1.5
			);


		var i:Int = 1;
		for( text_line in _menu_objs ) {
			text_line.fadeIn(
				new Vector(Luxe.screen.w*4.5/6, text_line.pos.y),
				0.5, 1.5 + 0.1*i
				);
			i++;
		}

		if(_localStrg.isLocalSaveSupported()) {
			var score:Float = Std.parseFloat(_localStrg.loadData(GameState.highscoreKey));
			_highscoreString = "Highscore : " + (Math.isNaN(score) ? "0" : Std.string(Std.int(score)));
			_highscore.text = _highscoreString;
		}
		_highscore.fadeIn(new Vector(0,0), 0.5, 1.5);

		ev.schedule(1.8, "ready");
		_square.animBigger(1);
    } //ready

    override function onleave<T>( _data:T ) {
    	_title.fadeOut(
    		0.5, 0
    		);


    	var i:Int = 1;
    	for( text_line in _menu_objs ) {
    		text_line.fadeOut(
    			0.5, 0.1*i
    			);
    		i++;
    	}

    	_highscore.fadeOut(0.5);

    }

    override function update( delta:Float ) {
    }


    #if !web
    override function onkeydown( event:KeyEvent) {
    	if( event.keycode == Key.escape)
    	Luxe.shutdown();
    }
    #end

    override function onmousedown( event:MouseEvent ) {
    	//machine.set('Game', {name:'Game', square:_square});
    	if( !readyPlay ) return;
    	_g.init();
    	machine.set('Game');
    }
}