package;  

import flash.display.Stage;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import org.flixel.*;
import flixel.FlxSprite;

class Registry 
{  
		public static var _player:Player;
		public static var _map:FlxOgmoLoader; //this is intantiated in Playstate
		public static var _hiScore:Int = 0;
		public static var _mWalls:FlxTilemap;
		public static var _earth:Earth;
		public static var _earthPos:FlxPoint; 
		public static var _enmHotspot:FlxSprite;
		public static var _sndAlert:FlxSound;

		public function Registry() 
		{
		
		}
		
}
