package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

/**
 * ...
 * @author ...
 */
class EnemySpawner
{
	private var _enmSpnPts:Array<FlxPoint> = new Array();
	private var _map = new FlxOgmoLoader(AssetPaths.room_002b__oel);
	private var _numSpnPts:Int;
	private var _rdmInt:Int;
	
	public function new() 
	{
		/*
		 * TODO
		 * 
		 * find all the spawn points in the level
		 * //enemy_spawnpoint
		 * 
		 * add them to array
		 * add spawn method that creates an enemy at one of these points randomly
		 * 
		 * make sure you don't add two enemies at same spawn point
		 * */
		
		//find all the spawn points in the level
		_map.loadEntities(getEnmSpnPts, "entities");
		
	}
	
	public function spawn():Enemy
	{		
		_rdmInt = Std.random(4);
		var _rdmSpnPt:FlxPoint = _enmSpnPts[_rdmInt]; //get random position from _enmSpnPts
		trace(_enmSpnPts[0]);
		var _enm:Enemy = new Enemy(_rdmSpnPt.x, _rdmSpnPt.y);
		return _enm;
	}
	
	
	private function getEnmSpnPts(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		
		if (entityName == "enemy_spawnpoint")
		{
			trace("added _enmSpnPt!");
			_enmSpnPts.push(new FlxPoint(x, y));
			//_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
	
}