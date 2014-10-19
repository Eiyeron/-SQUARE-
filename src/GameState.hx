import luxe.Color;
import luxe.Sprite;
import luxe.Input;
import luxe.Vector;
import luxe.States;
import luxe.tween.Actuate;
import luxe.utils.Maths;
import phoenix.BitmapFont;
import luxe.Events;
import luxe.collision.Collision;

import io.LocalSave;

typedef GameStateTypedArgs = {
	name : String,
	cube : CubeTransition
}

class GameState extends luxe.State {

	public static inline var highscoreKey:String =" [SQUARE] highscore";

	private var cube     : CubeTransition;
	private var started  : Bool;
	private var obstacles: Array<Obstacle>;
	private var bonuses  : Array<Bonus>;
	private var ev       : Events;
	private var score    : Float;
	private var score_txt: MenuText;
	private var font     : BitmapFont;
	private var volume   : Float;

	public function new( data:GameStateTypedArgs ) {
		super({ name:data.name });
		cube = data.cube;
		obstacles = new Array<Obstacle>();
		bonuses = new Array<Bonus>();
		ev = new Events();
		font = Luxe.loadFont('open_sans.fnt', 'assets/open_sans/');
		score_txt = new MenuText(new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y + 50),
			"A", font, 96, 0xD64937);
		score_txt.color.a = 0;
		score_txt.depth = -0.5;
		volume = 0;

	}


	override function init<T>() {
		started = false;
		ev.listen("addBonus", addBonus);
		ev.listen("addObstacle", addObstacle);
		ev.listen("gameOver", gameOver);
		score_txt.text = "0";
		score = 0;	
		score_txt.fadeIn(Luxe.screen.mid, 1);
	}


	override function onenter<T>( data:T ) {
		cube.animSmaller(0);
		Actuate.tween(cube.pos, 0.25, {x:Luxe.mouse.x, y:Luxe.mouse.y})
		.onComplete(begin);
	}

	override function onleave<T>( data:T ) {
		Luxe.audio.stop("music");
		while(obstacles.length != 0)
		obstacles.pop().destroy();
		while(bonuses.length != 0)
		bonuses.pop().destroy();
		ev.clear();
		score_txt.fadeOut();

	}

	override function update( delta:Float) {
		cube.rotation_z -= 40 * delta;
		if( !started) return;
		score += delta;
		score_txt.text = Std.string(Std.int(score));
		for( i in obstacles) {
			var res = Collision.test(cast(cube.components.get("hitbox"), components.Hitbox).boundingBox, cast(i.components.get("hitbox"), components.Hitbox).boundingBox);
			if( res != null) {
				ev.queue("gameOver");
				break;			
			}
		}
		for( i in bonuses) {
			var res = Collision.test(cast(cube.components.get("hitbox"), components.Hitbox).boundingBox, cast(i.components.get("hitbox"), components.Hitbox).boundingBox);
			if( res != null) {
				// TODO UGLYYY, should use a caller or something in that idea.
				cast(i.components.get("move"), components.MovingEntity).replace( );
				score += 10;
				break;
			}
		}
		ev.process();
	}

	function gameOver<T>( data:T ) {
		Luxe.audio.play('hit');
		started = false;

		var save = new LocalSave();
		if(save.isLocalSaveSupported()) {
			var existingScore:String = save.loadData(highscoreKey);
			var scoreFromFile:Float = 0;
			scoreFromFile = Std.parseFloat(existingScore);
			if(Math.isNaN(scoreFromFile) || scoreFromFile < this.score) {
				trace("New highscore : " + this.score);
				save.saveData(highscoreKey, Std.string(this.score));
			}

		}

		#if web
		Luxe.audio.stop("music");
		
		#else
		Actuate.update(Luxe.audio.volume, 1, ["music", 1], ["music", 0]);
		#end

		Actuate.tween(Luxe, 1, {timescale:0})
		.ease(luxe.tween.easing.Expo.easeOut)
		.onComplete(machine.set, ["Menu"]);
	}

	function addBonus<T>( data:T ) {
		bonuses.push( new Bonus( ));
		ev.schedule(8, "addBonus");
	}

	function addObstacle<T>( data:T ) {
		obstacles.push( new Obstacle( ));
		ev.schedule(5, "addObstacle");
	}

	function begin() {
		started = true;
		for( i in 0 ... 5 ) {
			var obs:Obstacle = new Obstacle();
			obstacles.push(obs);
		}
		for( i in 0 ... 5 ) {
			var obs:Bonus = new Bonus();
			bonuses.push(obs);
		}
		addObstacle( null );
		addBonus( null );

		Luxe.audio.on('music', 'load', function(s:luxe.Sound) {
			#if web
			Luxe.audio.volume("music", 1);
			#else
			Actuate.update(Luxe.audio.volume, 1, ["music", 0], ["music", 1]);
	
			#end
			Luxe.audio.loop('music');
			});

	}
	
	override function ontouchmove( event:TouchEvent) {
		cube.pos = event.pos;
	}

	override function onmousemove( event:MouseEvent ) {
		if( !started ) return;
		cube.pos = event.pos;

	}

	override function onkeydown( event:KeyEvent) {
		if( event.keycode == Key.escape && this.started)
		gameOver(null);
	}
}