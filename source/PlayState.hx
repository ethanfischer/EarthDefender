package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import lime.math.Rectangle;
using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 * 
 * 
 * TODO
 * 
 * -make enemies spawn randomly on map
 * 
 * 
 */
class PlayState extends FlxState
{
	//FlxG.log.redirectTraces = true;
	
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	//private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	private var _hud:HUD;
	private var _money:Int = 0;
	private var _health:Int = 3;
	//private var _inCombat:Bool = false;
	//private var _combatHud:CombatHUD;
	private var _ending:Bool;
	private var _won:Bool;
	private var _paused:Bool;
	private var _sndCoin:FlxSound;
	private var _coin:Coin;
	private var _enmSpawner:EnemySpawner;
	private var _enmHotspot:FlxObject;
	
	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_map = new FlxOgmoLoader(AssetPaths.room_002c3__oel);
		
		//_map = new FlxOgmoLoader(AssetPaths.room_001a__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		_mWalls.setTileProperties(3, FlxObject.NONE);
	
		add(_mWalls);
		
		//_grpCoins = new FlxTypedGroup<Coin>();
		//add(_grpCoins);
		
		//EnemySpawner
		_grpEnemies = new FlxTypedGroup<Enemy>();
		_enmSpawner = new EnemySpawner();
		var _enm:Enemy = _enmSpawner.spawn();
		_grpEnemies.add(_enm);
		add(_grpEnemies);
		
		_player = new Player(128, 128, _mWalls);
		
		_map.loadEntities(placeEntities, "entities");
		add(_coin);
		
		add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, 1);
		
		_hud = new HUD();
		add(_hud);
		
		//_combatHud = new CombatHUD();
		//add(_combatHud);
		
		_sndCoin = FlxG.sound.load(AssetPaths.coin__wav);
		
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);		
		add(virtualPad);
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();	
		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_coin = new Coin(x + 4, y + 4);
			
		}
		else if (entityName == "hotspot")
		{
			_enmHotspot = new FlxObject(Std.int(x),Std.int(y), 224, 224);
		}
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_player = FlxDestroyUtil.destroy(_player);
		_mWalls = FlxDestroyUtil.destroy(_mWalls);
		//_grpCoins = FlxDestroyUtil.destroy(_grpCoins);
		_grpEnemies = FlxDestroyUtil.destroy(_grpEnemies);
		_hud = FlxDestroyUtil.destroy(_hud);
		//_combatHud = FlxDestroyUtil.destroy(_combatHud);
		_sndCoin = FlxDestroyUtil.destroy(_sndCoin);
		#if mobile
		virtualPad = FlxDestroyUtil.destroy(virtualPad);
		#end
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (_ending)
		{
			FlxG.switchState(new GameOverState(false, 0));
			return;
		}
		
		
		//FlxG.log.redirectTraces = true;
		//FlxG.overlap(_mWalls, _player, collideFunction);
		//FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		FlxG.collide(_grpEnemies, _mWalls);
		FlxG.collide(_grpEnemies, _coin, endGame);
		FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
		FlxG.overlap(_grpEnemies, _enmHotspot, enmTouchHotspot);
		_grpEnemies.forEachAlive(checkEnemyVision);
		/*if (!_inCombat)
		{*/
		//}
		/*else
		{*/
			//if (!_combatHud.visible)walls
			//{
				//_health = _combatHud.playerHealth;
				//_hud.updateHUD(_health, _money);
				//if (_combatHud.outcome == DEFEAT)
				//{
					//_ending = true;
					//FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
				//}
				//else
				//{
					//if (_combatHud.outcome == VICTORY)
					//{
						//_combatHud.e.kill();
						//if (_combatHud.e.etype == 1)
						//{
							//_won = true;
							//_ending = true;
							//FlxG.camera.fade(FlxColor.BLACK, .33, false, doneFadeOut);
						//}
					//}
					//else 
					//{
						//_combatHud.e.flicker();
					//}
					//#if mobile
					//virtualPad.visible = true;
					//#end
					//_inCombat = false;
					//_player.active = true;
					//_grpEnemies.active = true;
				//}
			//}
		//}
	
	}
	
	private function doneFadeOut():Void 
	{
		FlxG.switchState(new GameOverState(_won, _money));
	}
	
	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering())
		{
			E.kill();
			spawnEnemy();
		}
	}
	
	//private function startCombat(E:Enemy):Void
	//{
		//_inCombat = true;
		//_player.active = false;
		//_grpEnemies.active = false;
		////_combatHud.initCombat(_health, E);
		//#if mobile
		//virtualPad.visible = false;
		//#end
	//}
	
	private function checkEnemyVision(e:Enemy):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.coinPos.copyFrom(new FlxPoint(_coin.x, _coin.y));
		}
		else
			e.seesPlayer = false;		
	}
	
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			_sndCoin.play(true);
			_money++;
			_hud.updateHUD(_health, _money);
			C.kill();
		}
	}
	
	private function spawnEnemy():Void
	{
		var _enm:Enemy = _enmSpawner.spawn();
		_grpEnemies.add(_enm);
		add(_enm); //add the enemy to the scene
	}

	private function endGame(E:Enemy, C:Coin):Void
	{
		_ending = true;
	}
	
	private function enmTouchHotspot(E:Enemy, HtSp:FlxObject):Void
	{
		E.go4it();
	}
}
