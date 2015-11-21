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
	private var _map = Registry._map;
	private var _numSpnPts:Int;
	private var _rdmInt:Int;
	private var _prvEnmSpnPt:FlxPoint;
	
	public function new() 
	{
		/*
		 * TODO
		 * 
		 * find all the spawn points in the level
		 * 
		 * 
		 * 
		 *
		 * 
		 * make sure you don't add two enemies at same spawn point
		 * */
		
		//find all the spawn points in the level
		_map.loadEntities(getEnmSpnPts, "entities");
		
	}
	
	public function spawn():Enemy
	{		
		var _rdmSpnPt:FlxPoint = new FlxPoint(0,0);
		while (true)
		{
			_rdmInt = Std.random(4);
			_rdmSpnPt = _enmSpnPts[_rdmInt]; //get random position from _enmSpnPts
			
			if (_prvEnmSpnPt != _rdmSpnPt)
			{
				var _enm:Enemy = new Enemy(_rdmSpnPt.x, _rdmSpnPt.y);
				_prvEnmSpnPt = _rdmSpnPt;
				return _enm;
			}
		}
		
	}
	
	
	private function getEnmSpnPts(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		
		if (entityName == "enemy_spawnpoint")
		{
			_enmSpnPts.push(new FlxPoint(x, y));
			//_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
	
}