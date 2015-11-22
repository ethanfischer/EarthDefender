package;  

import flash.display.Stage;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import org.flixel.*;

class Registry 
{  
		public static var _player:Player;
		public static var _map:FlxOgmoLoader; //this is intantiated in Playstate
		public static var _hiScore:Int = 0;
		
		public function Registry() 
		{
		
		}
		
}
