package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/data/room-001.oel", "assets/data/room-001.oel");
			type.set ("assets/data/room-001.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-001a.oel", "assets/data/room-001a.oel");
			type.set ("assets/data/room-001a.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002.oel", "assets/data/room-002.oel");
			type.set ("assets/data/room-002.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002a.oel", "assets/data/room-002a.oel");
			type.set ("assets/data/room-002a.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002b.oel", "assets/data/room-002b.oel");
			type.set ("assets/data/room-002b.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002c.oel", "assets/data/room-002c.oel");
			type.set ("assets/data/room-002c.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002c1.oel", "assets/data/room-002c1.oel");
			type.set ("assets/data/room-002c1.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002c2.oel", "assets/data/room-002c2.oel");
			type.set ("assets/data/room-002c2.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002c3.oel", "assets/data/room-002c3.oel");
			type.set ("assets/data/room-002c3.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002c3B.oel", "assets/data/room-002c3B.oel");
			type.set ("assets/data/room-002c3B.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/room-002d.oel", "assets/data/room-002d.oel");
			type.set ("assets/data/room-002d.oel", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tutorial.oep", "assets/data/tutorial.oep");
			type.set ("assets/data/tutorial.oep", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/button.png", "assets/images/button.png");
			type.set ("assets/images/button.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/coin.png", "assets/images/coin.png");
			type.set ("assets/images/coin.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/enemy-0.png", "assets/images/enemy-0.png");
			type.set ("assets/images/enemy-0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/enemy-1.png", "assets/images/enemy-1.png");
			type.set ("assets/images/enemy-1.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/health.png", "assets/images/health.png");
			type.set ("assets/images/health.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/player.png", "assets/images/player.png");
			type.set ("assets/images/player.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/pointer.png", "assets/images/pointer.png");
			type.set ("assets/images/pointer.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/tiles.png", "assets/images/tiles.png");
			type.set ("assets/images/tiles.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sounds/coin.wav", "assets/sounds/coin.wav");
			type.set ("assets/sounds/coin.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/combat.wav", "assets/sounds/combat.wav");
			type.set ("assets/sounds/combat.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/fled.wav", "assets/sounds/fled.wav");
			type.set ("assets/sounds/fled.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/hurt.wav", "assets/sounds/hurt.wav");
			type.set ("assets/sounds/hurt.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/lose.wav", "assets/sounds/lose.wav");
			type.set ("assets/sounds/lose.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/miss.wav", "assets/sounds/miss.wav");
			type.set ("assets/sounds/miss.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/select.wav", "assets/sounds/select.wav");
			type.set ("assets/sounds/select.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/step.wav", "assets/sounds/step.wav");
			type.set ("assets/sounds/step.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/win.wav", "assets/sounds/win.wav");
			type.set ("assets/sounds/win.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/music/HaxeFlixel_Tutorial_Game.ogg", "assets/music/HaxeFlixel_Tutorial_Game.ogg");
			type.set ("assets/music/HaxeFlixel_Tutorial_Game.ogg", Reflect.field (AssetType, "music".toUpperCase ()));
			path.set ("assets/sounds/beep.ogg", "assets/sounds/beep.ogg");
			type.set ("assets/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/flixel.ogg", "assets/sounds/flixel.ogg");
			type.set ("assets/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/fonts/nokiafc22.ttf", "assets/fonts/nokiafc22.ttf");
			type.set ("assets/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("assets/fonts/arial.ttf", "assets/fonts/arial.ttf");
			type.set ("assets/fonts/arial.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
