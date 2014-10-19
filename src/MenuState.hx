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
	cube : CubeTransition

}

class MenuState extends luxe.State {

	public var cube     : CubeTransition;
	public var title    : MenuText;
	public var menu_text: Array<String>;
	public var menu_objs: Array<MenuText>;
	public var highscore: MenuText;
	public var highscoreString:String;	
	public var font     : BitmapFont;
	public var g        : GameState;
	public var localStrg: LocalSave;


	private var ev:Events;
	public var readyPlay: Bool;


	public function new( _data:MenuStateTypedArgs ) {
		super({ name:_data.name });
		machine = _data.machine;
		cube = _data.cube;
		ev = new Events();
		ev.listen("ready", readyToPlay);
		localStrg = new LocalSave();

	}

	override function init() {
		menu_text = ["Click", "to", "Play", "[By Eiyeron]"];
		menu_objs = new Array<MenuText>();
		font = /*Luxe.loadFont('open_sans.fnt', 'assets/open_sans/');*/Luxe.resources.find_font('open_sans');

		title = new MenuText(
			new Vector(Luxe.screen.w*4.7/6, Luxe.screen.h/5),
			'[SQUARE]', font, 40, 0xdedede
			);
		title.color.a = 0;

		var i:Int = 0;
		for( line in menu_text ) {
			var text_line = new MenuText(
				new Vector(Luxe.screen.w*4.7/6, 2*Luxe.screen.h/5 + Luxe.screen.h*i/8),
				line, font, 30, 0xdedede
				);
			text_line.color.a = 0;
			menu_objs.push(text_line);
			i++;
		}
		highscoreString = "Highscore unsupported here";
		highscore = new MenuText(new Vector(-Luxe.screen.w/6,0), 
			highscoreString,
			font,
			24,
			0xdedede,
			TextAlign.left);
		highscore.color.a = 0;

		g = new GameState({name:'Game', cube:cube});
		machine.add( g );
	}

	function readyToPlay<T>( _data:T ) {
		readyPlay = true;
	}

	override function onenter<T>( _data:T ) {
		readyPlay = false;
		Luxe.timescale = 1;


		Actuate.tween(cube.pos, 0.5, {x:Luxe.screen.mid.x/4., y:Luxe.screen.mid.y});

		title.fadeIn(
			new Vector(Luxe.screen.w*4.5/6, title.pos.y),
			0.5, 1.5
			);


		var i:Int = 1;
		for( text_line in menu_objs ) {
			text_line.fadeIn(
				new Vector(Luxe.screen.w*4.5/6, text_line.pos.y),
				0.5, 1.5 + 0.1*i
				);
			i++;
		}

		if(localStrg.isLocalSaveSupported()) {
			var score:Float = Std.parseFloat(localStrg.loadData(GameState.highscoreKey));
			highscoreString = "Highscore : " + (Math.isNaN(score) ? "0" : Std.string(Std.int(score)));
			highscore.text = highscoreString;
		}
		highscore.fadeIn(new Vector(0,0), 0.5, 1.5);

		ev.schedule(1.8, "ready");
		cube.animBigger(1);
    } //ready

    override function onleave<T>( _data:T ) {
    	title.fadeOut(
    		0.5, 0
    		);


    	var i:Int = 1;
    	for( text_line in menu_objs ) {
    		text_line.fadeOut(
    			0.5, 0.1*i
    			);
    		i++;
    	}

    	highscore.fadeOut(0.5);

    }

    override function update( delta:Float ) {
    	if( cube != null ) {
    		cube.rotation_z += 60 * delta;
    	}
    }


    #if !web
    override function onkeydown( event:KeyEvent) {
    	if( event.keycode == Key.escape)
    	Luxe.shutdown();
    }
    #end

    override function onmousedown( event:MouseEvent ) {
    	//machine.set('Game', {name:'Game', cube:cube});
    	if( !readyPlay ) return;
    	g.init();
    	machine.set('Game');
    }
}