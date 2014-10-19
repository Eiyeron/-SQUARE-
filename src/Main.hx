import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Input;
import luxe.Text;
import luxe.Parcel;
import luxe.ParcelProgress;
import luxe.States;
import luxe.tween.Actuate;

import phoenix.BitmapFont;

class Main extends luxe.Game {

    public var progress : ParcelProgress;
    public var machine  : States;
    public var menuState: MenuState;
    public var cube     : CubeTransition;

    override function ready() {
        Luxe.renderer.clear_color.rgb(0x2D2D2D);
        cube = new CubeTransition(Luxe.screen.mid, 1, 16);
        Actuate.tween(cube.pos, 1, {y:Luxe.screen.mid.y/2,}).ease( luxe.tween.easing.Sine.easeOut ).repeat().reflect();
        Actuate.tween(cube, 1, {rotation_z:60,}).ease( luxe.tween.easing.Linear.easeNone ).repeat();

        var json_asset = Luxe.loadJSON('assets/parcel.json');


        //fetch a list of assets to load from the json file
        //then create a parcel to load it for us
        var preload = new Parcel();
        preload.from_json(json_asset.json);

        //but, we also want a progress bar for the parcel,
        //this is a default one, you can do your own
        progress = new ParcelProgress({
            parcel      : preload,
            background  : new Color().rgb(0x2D2D2D),
            bar         : new Color().rgb(0xD64927),
            bar_border  : new Color().rgb(0xDEDEDE),
            oncomplete  : loadEverything,
            fade_in     : false,
            fade_out    : true
            });
        //go!
        preload.load();


        machine = new States({name: "machine"});
        menuState =  new MenuState({name:'Menu', machine:machine, cube:cube});
        machine.add(menuState);

    } //ready

    function loadEverything( parcel:Parcel ) {
        Actuate.reset();
        machine.set('Menu');
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