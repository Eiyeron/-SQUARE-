import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Text;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States;
import luxe.tween.Actuate;

import phoenix.BitmapFont;

class Main extends luxe.Game {

    private var _machine   : States;
    private var _menuState : MenuState;
    private var _progress  : ParcelProgress;
    private var _square    : PlayerSquare;

    override function ready() {
        Luxe.renderer.clear_color.rgb(0x2D2D2D);
        _square = new PlayerSquare(Luxe.screen.mid, 1, 16);
        _square.add(new components.RotatingEntity("rotation", 60));
        Actuate.tween(_square.pos, 1, {y:Luxe.screen.mid.y/2,}).ease( luxe.tween.easing.Sine.easeOut ).repeat().reflect();

        var json_asset = Luxe.loadJSON('assets/parcel.json');


        //fetch a list of assets to load from the json file
        //then create a parcel to load it for us
        var preload = new Parcel();
        preload.from_json(json_asset.json);

        //but, we also want a progress bar for the parcel,
        //this is a default one, you can do your own
        _progress = new ParcelProgress({
            parcel      : preload,
            background  : new Color(0, 0, 0, 0),
            bar         : new Color().rgb(0xD64927),
            bar_border  : new Color().rgb(0xDEDEDE),
            oncomplete  : launchEverything,
            fade_in     : false,
            fade_out    : true
            });
        //go!
        preload.load();



    } //ready

    function launchEverything( parcel:Parcel ) {
        trace(parcel.fonts.toString( ));
        _machine = new States({name: "machine"});
        _menuState =  new MenuState({name:'Menu', machine:_machine, square:_square});
        _menuState.init();
        _machine.add(_menuState);
        Actuate.reset();
        _machine.set('Menu');
    }


      //overriding the built in function to configure the default window
      override function config( config:AppConfig ) : AppConfig {

        if(config.runtime.window != null) {
            if(config.runtime.window.width != null) {
                config.window.width = Std.int(config.runtime.window.width);
            }
            if(config.runtime.window.height != null) {
                config.window.height = Std.int(config.runtime.window.height);
            }
        }

        config.window.title = config.runtime.name;
        // config.window.antialiasing = 2;

        return config;

    } //config
} //Main
