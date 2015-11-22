#if !macro


@:access(lime.app.Application)
@:access(lime.Assets)
@:access(openfl.display.Stage)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new openfl.display.Application ();
		app.create (config);
		
		var display = new flixel.system.FlxPreloader ();
		
		preloader = new openfl.display.Preloader (display);
		app.setPreloader (preloader);
		preloader.onComplete.add (init);
		preloader.create (config);
		
		#if (js && html5)
		var urls = [];
		var types = [];
		
		
		urls.push ("assets/data/room-001.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-001a.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002a.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002b.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002c.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002c1.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002c2.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002c3.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002c3B.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002d.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002e.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/room-002path.oel");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/data/tutorial.oep");
		types.push (lime.Assets.AssetType.TEXT);
		
		
		urls.push ("assets/images/button.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/coin.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/enemy-0.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/enemy-1.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/health.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/player.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/pointer.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/images/tiles.png");
		types.push (lime.Assets.AssetType.IMAGE);
		
		
		urls.push ("assets/sounds/alert.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/coin.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/combat.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/fled.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/gameover.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/hurt.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/lose.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/miss.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/select.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/step.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/sounds/win.wav");
		types.push (lime.Assets.AssetType.SOUND);
		
		
		urls.push ("assets/music/HaxeFlixel_Tutorial_Game.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/beep.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("assets/sounds/flixel.mp3");
		types.push (lime.Assets.AssetType.MUSIC);
		
		
		urls.push ("Nokia Cellphone FC Small");
		types.push (lime.Assets.AssetType.FONT);
		
		
		urls.push ("Arial");
		types.push (lime.Assets.AssetType.FONT);
		
		
		
		if (config.assetsPrefix != null) {
			
			for (i in 0...urls.length) {
				
				if (types[i] != lime.Assets.AssetType.FONT) {
					
					urls[i] = config.assetsPrefix + urls[i];
					
				}
				
			}
			
		}
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if (sys && !nodejs && !emscripten)
		Sys.exit (result);
		#end
		
	}
	
	
	public static function init ():Void {
		
		var loaded = 0;
		var total = 0;
		var library_onLoad = function (__) {
			
			loaded++;
			
			if (loaded == total) {
				
				start ();
				
			}
			
		}
		
		preloader = null;
		
		
		
		if (total == 0) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			build: "653",
			company: "HaxeFlixel",
			file: "TurnBasedRPG",
			fps: 60,
			name: "TurnBasedRPG",
			orientation: "portrait",
			packageName: "com.haxeflixel.tutorial",
			version: "0.0.1",
			windows: [
				
				{
					antialiasing: 0,
					background: 0,
					borderless: false,
					depthBuffer: false,
					display: 0,
					fullscreen: false,
					hardware: true,
					height: 640,
					parameters: "{}",
					resizable: true,
					stencilBuffer: true,
					title: "TurnBasedRPG",
					vsync: true,
					width: 860,
					x: null,
					y: null
				},
			]
			
		};
		
		#if hxtelemetry
		var telemetry = new hxtelemetry.HxTelemetry.Config ();
		telemetry.allocations = true;
		telemetry.host = "localhost";
		telemetry.app_name = config.name;
		Reflect.setField (config, "telemetry", telemetry);
		#end
		
		#if (js && html5)
		#if (munit || utest)
		openfl.Lib.embed (null, 860, 640, "000000");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		var hasMain = false;
		var entryPoint = Type.resolveClass ("Main");
		
		for (methodName in Type.getClassFields (entryPoint)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		lime.Assets.initialize ();
		
		if (hasMain) {
			
			Reflect.callMethod (entryPoint, Reflect.field (entryPoint, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		#if !flash
		if (openfl.Lib.current.stage.window.fullscreen) {
			
			openfl.Lib.current.stage.dispatchEvent (new openfl.events.FullScreenEvent (openfl.events.FullScreenEvent.FULL_SCREEN, false, false, true, true));
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		#end
		
	}
	
	
	#if neko
	@:noCompletion @:dox(hide) public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends Main {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
