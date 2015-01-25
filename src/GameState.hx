import luxe.Events;
import luxe.Color;
import luxe.Input;
import luxe.Sprite;
import luxe.States;
import luxe.Vector;
import luxe.collision.Collision;
import luxe.utils.Maths;
import luxe.tween.Actuate;

import phoenix.BitmapFont;

import components.Hitbox;
import components.MovingEntity;
import components.RotatingEntity;

import effects.EffectManager;

import io.LocalSave;

typedef GameStateTypedArgs = {
	name : String,
	square : PlayerSquare,
	musicPlaying : Bool
}

class GameState extends State {

	public static inline var highscoreKey:String =" [SQUARE] highscore";

	private var _bonuses      : Array<Pickup>;
	private var _eManager     : EffectManager;
	private var _ev           : Events;
	private var _font         : BitmapFont;
	private var _obstacles    : Array<Obstacle>;
	private var _score        : Float;
	private var _score_txt    : MenuText;
	private var _square       : PlayerSquare;
	private var _started      : Bool;
	private var _musicPlaying : Bool;

	public function new( data:GameStateTypedArgs ) {
		super({ name:data.name });
		_square = data.square;
		_obstacles = new Array<Obstacle>();
		_bonuses = new Array<Pickup>();
		_ev = new Events();
		_font = Luxe.resources.find_font('open_sans');
		_score_txt = new MenuText(new Vector(Luxe.screen.mid.x, Luxe.screen.mid.y + 50),
			"0", _font, 96, 0xD64937);
		_score_txt.color.a = 0;
		_score_txt.depth = -0.5;
		_eManager = new EffectManager();
		_musicPlaying = data.musicPlaying;
	}

	override function init<T>() {
		_started = false;
		_ev.listen("addPickup", addPickup);
		_ev.listen("addObstacle", addObstacle);
		_ev.listen("gameOver", gameOver);
		//Global event for inter-object communication
		Luxe.events.listen("bonusPoints", bonusPoints);
		
		_score_txt.fadeIn(Luxe.screen.mid, 1);

	}

	override function onenter<T>( data:T ) {
		var args: GameStateTypedArgs = cast data;
		_musicPlaying = args.musicPlaying;

		_square.animSmaller(0);
		cast(_square.get("rotation"), RotatingEntity).setNewVelocity( -40 );
		Actuate.tween(_square.pos, 0.25, {x:Luxe.screen.cursor.pos.x, y:Luxe.screen.cursor.pos.y})
		.onComplete(begin);
		_score_txt.text = "0";
		_score = 0;	
	}

	override function onleave<T>( data:T ) {
		Luxe.audio.stop("music");
		while(_obstacles.length > 0)
		_obstacles.pop().destroy();
		while(_bonuses.length > 0)
		_bonuses.pop().destroy();
		_ev.clear();
		Luxe.events.clear();
		_score_txt.fadeOut();

	}

	private function hasCollidedToCube(spr:Sprite):Bool {
		return Hitbox.testCollisionBetweenHitboxes(cast(_square.components.get("hitbox"), Hitbox), cast(spr.components.get("hitbox"), Hitbox));
	}

	private function addPickup<T>( data:T ) {
		_bonuses.push( new Pickup( ));
		_ev.schedule(8 + Maths.random_float(0, 8), "addPickup");
	}

	private function addObstacle<T>( data:T ) {
		_obstacles.push( new Obstacle( ));
		_ev.schedule(5 + Maths.random_float(0, 2), "addObstacle");
	}

	private function bonusPoints<T> ( data:T ) {
		_score += 50;
	}

	private function fadeInMusic( ) {
		_musicPlaying = true;
		Luxe.audio.loop('music');
		#if web
		#else
		Actuate.update(Luxe.audio.volume, 1, ["music", 0], ["music", 1]);
		#end
	}

	private function fadeOutMusic( ) {
		_musicPlaying = false;
		#if web
		Luxe.audio.stop('music');
		#else
		Actuate.update(Luxe.audio.volume, 1, ["music", 1], ["music", 0])
		.onComplete(Luxe.audio.stop, ["music"]);
		#end
	}

	private function begin() {
		_started = true;
		for( i in 0 ... 5 ) {
			var obs:Obstacle = new Obstacle();
			_obstacles.push(obs);
		}
		for( i in 0 ... 5 ) {
			var obs:Pickup = new Pickup();
			_bonuses.push(obs);
		}
		addObstacle( null );
		addPickup( null );
		if(_musicPlaying)
			fadeInMusic();

	}

	override function update( delta:Float) {
		if( !_started) return;
		_score += delta;
		_score_txt.text = Std.string(Std.int(_score));

		if(Lambda.exists(_obstacles, hasCollidedToCube)) {
			_ev.queue("gameOver");			
		}

		Lambda.map( Lambda.filter(_bonuses, hasCollidedToCube), function( i ) {
			cast(i.components.get("move"), MovingEntity).replace( );
			_score += 10;
			Luxe.audio.play('bleep');
			if(Maths.random_int(0, 50) == 0)
			_eManager.startRandom();
			});

		_ev.process();
	}

	private function gameOver<T>( data:T ) {
		Luxe.audio.play('hit');
		_started = false;

		var save = new LocalSave();
		// TODO : make the save more clear here. Process more conditions on the LocalSave
		if(save.isLocalSaveSupported()) {
			var existingScore:String = save.loadData(highscoreKey);
			var scoreFromFile:Float = 0;
			scoreFromFile = Std.parseFloat(existingScore);
			if(Math.isNaN(scoreFromFile) || scoreFromFile < _score) {
				trace("New highscore : " + _score);
				save.saveData(highscoreKey, Std.string(_score));
			}

		}

		_eManager.endAll();

		fadeOutMusic();

		Actuate.tween(Luxe, 1, {timescale:0}, true)
		.ease(luxe.tween.easing.Expo.easeOut)
		.onComplete(machine.set, ["Menu"]);
	}

	function toggleMute() {
			if(_musicPlaying)
				fadeOutMusic();
			else
				fadeInMusic();
	}

	override function ontouchmove( event:TouchEvent) {
		_square.pos = event.pos;
	}

	override function onmousemove( event:MouseEvent ) {
		if( !_started ) return;
		_square.pos = event.pos;

	}

	override function onkeydown( event:KeyEvent) {
		if( event.keycode == Key.key_m) 
		{
			toggleMute();
		}
		if( event.keycode == Key.escape && _started)
		gameOver(null);
	}
}