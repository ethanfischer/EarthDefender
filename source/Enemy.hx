package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxAngle;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;
using flixel.util.FlxSpriteUtil;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

/*
 * TODO
 * 
 * -make enemies move tile-by-tile
 * -make enemies hide in shadows when they see you
 * -make enemies run when you get close to them
 * -implement path finding for getting to the globe, moving away from player
 * 
*/

class Enemy extends FlxSprite
{
	public var speed:Float = 80;
	public var etype(default, null):Int;
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	public var coinPos(default, null):FlxPoint;
	private var _going4it:Bool = false;
	private var _player:Player;
	private var _htspFlag:Bool = false;

	
	//corners of the map used for moving away from the player
	private var _UL:FlxPoint; //upleft
	private var _UR:FlxPoint; //upright
	private var _DL:FlxPoint; //downleft
	private var _DR:FlxPoint; //downright
	
	//private var _sndStep:FlxSound;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/enemy-0.png", true, 16, 16);
		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		//animation.add("d", [0, 1, 0, 2], 6, false);
		//animation.add("lr", [3, 4, 3, 5], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		//drag.x = drag.y = 10;
		width = 16;
		height = 16;
		_brain = new FSM(chase);
		_idleTmr = 0;
		
		scrollFactor.x = 1;
		scrollFactor.y = 1;
		
		_UL = new FlxPoint(0, 0);
		_UR = new FlxPoint(Registry._map.width, 0);
		_DL = new FlxPoint(0, Registry._map.height);
		_DR = new FlxPoint(Registry._map.width, Registry._map.height);
		
		coinPos = FlxPoint.get();
		
		//_sndStep = FlxG.sound.load(AssetPaths.step__wav,.4);
		//_sndStep.proximity(x,y,FlxG.camera.target, FlxG.width *.6);
	}
	
	override public function update():Void 
	{
		//if (isFlickering())
			//return;
		_brain.update();
		super.update();
	
		//if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		//{
			////_sndStep.setPosition(x + _halfWidth, y + height);
			////_sndStep.play();
		//}
	}
	
	//public function idle():Void //TODO only call idle when enemy sees player and is in shadows
	//{
		//trace("idle");
		//if (seesPlayer)
		//{
			////TODO hide
			//_brain.activeState = flee;
			//velocity.x = velocity.y = 0;
		//}
		//else
		//{
			//_brain.activeState = chase;
		//}
		//
		////else if (_idleTmr <= 0)
		////{
			////if (FlxRandom.chanceRoll(1))
			////{
				////_moveDir = -1;
				////velocity.x = velocity.y = 0;
			////}
			////else
			////{
				////_moveDir = FlxRandom.intRanged(0, 8) * 45;
				////FlxAngle.rotatePoint(speed * .5, 0, 0, 0, _moveDir, velocity);
				////
			////}
			////_idleTmr = FlxRandom.intRanged(1, 4);			
		////}
		////else
			////_idleTmr -= FlxG.elapsed;
		//
	//}
	
	public function chase():Void
	{
		
		if (seesPlayer && !_going4it) //TODO if in shadows, be idle. Otherwise, flee! FOr now, if sees player, flee!
		{
			//TODO hide in shadows
			flee();
		}
		else
		{	
			_brain.activeState = chase;
			FlxVelocity.moveTowardsPoint(this, coinPos, Std.int(speed));
		}
	}
	
	public function flee():Void
	{
		if (seesPlayer)
		{
			_brain.activeState = flee;
			
			moveAwayFromPlayer();
		} else
		{
			chase();
		}
	}
	
	override public function draw():Void 
	{
		if ((velocity.x != 0 || velocity.y != 0) && touching != FlxObject.NONE)
		{
			
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
			
			//switch(facing)
			//{
				//case FlxObject.LEFT, FlxObject.RIGHT:
					//animation.play("lr");
					//
				//case FlxObject.UP:
					//animation.play("u");
					//
				//case FlxObject.DOWN:
					//animation.play("d");
			//}
		}
			
		super.draw();
	}
	
	private function moveAwayFromPlayer():Void
	{
		//TODO make movement smarter/use path finding to get enemy to avoid colliding with walls
		var _player = Registry._player;
		//upperleft of player
		if (x < _player.x && y < _player.y) { 
			FlxVelocity.moveTowardsPoint(this, _UL, Std.int(speed));
			
		} 
		
		//upperright of player
		else if (x >= _player.x && y < _player.y) { 
			FlxVelocity.moveTowardsPoint(this, _UR, Std.int(speed));
		} 
		
		//downleft of player
		else if (x <= _player.x && y > _player.y) { 
			FlxVelocity.moveTowardsPoint(this, _DL, Std.int(speed));			
		} 
		
		//downright of player
		else if (x > _player.x &&  y > _player.y) { 
			FlxVelocity.moveTowardsPoint(this, _DR, Std.int(speed));
		}
	}
	
	public function changeEnemy(EType:Int):Void
	{
		if (etype != EType)
		{
			etype = EType;
			loadGraphic("assets/images/enemy-" + Std.string(etype) + ".png", true, 16, 16);
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		//_sndStep = FlxDestroyUtil.destroy(_sndStep);
	}
	
	public function go4it():Void
	{
		_going4it = true;
		chase();
	}
	
	public function getHtspFlag():Bool
	{
		return _htspFlag;
	}
	public function setHtspFlag(b:Bool):Void
	{
		_htspFlag = b;
	}
	
	//TODO maybe use this for enemy movement to be like player movement
	//public function moveTo(Direction:MoveDirection):Void //TODO
	//{
		///*Only change direction if not already moving*/
		//if (!moveToNextTile)
		//{
			//var tile:Int;
			//
			///*Check next tile relative to player's current tile and movement direction. If solid, don't allow movement
			//get tile moving to, based on players current tile and movedirection*/
			//
			///*cardinal*/
			//if (Direction == MoveDirection.UPTAP || Direction ==  MoveDirection.UPHOLD)
			//{
				//tile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y - TILE_SIZE)/TILE_SIZE));
			//} else if (Direction == MoveDirection.DOWNTAP || Direction == MoveDirection.DOWNHOLD)
			//{
				//tile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y + TILE_SIZE)/TILE_SIZE));
			//} else if (Direction == MoveDirection.LEFTTAP || Direction == MoveDirection.LEFTHOLD)
			//{
				//tile = _mWalls.getTile(Std.int((x-TILE_SIZE)/TILE_SIZE), Std.int(y/TILE_SIZE));
			//} else if (Direction == MoveDirection.RIGHTTAP || Direction == MoveDirection.RIGHTHOLD)
			//{
				//tile = _mWalls.getTile(Std.int((x+TILE_SIZE)/TILE_SIZE), Std.int(y/TILE_SIZE));
			//} 
			//
			///*diagonal*/
			//else if (Direction ==  MoveDirection.UPRIGHTHOLD)
			//{
				//tile = _mWalls.getTile(Std.int((x+TILE_SIZE)/TILE_SIZE), Std.int((y - TILE_SIZE)/TILE_SIZE));
			//} else if (Direction == MoveDirection.UPLEFTHOLD)
			//{
				//tile = _mWalls.getTile(Std.int((x-TILE_SIZE)/TILE_SIZE), Std.int((y - TILE_SIZE)/TILE_SIZE));
			//} else if (Direction == MoveDirection.DOWNRIGHTHOLD)
			//{
				//tile = _mWalls.getTile(Std.int((x+TILE_SIZE)/TILE_SIZE), Std.int((y+TILE_SIZE)/TILE_SIZE));
			//} else
			//{
				//tile = _mWalls.getTile(Std.int((x-TILE_SIZE)/TILE_SIZE), Std.int((y+TILE_SIZE)/TILE_SIZE));
			//} 
				//
			////if tile is collidible, don't move
			//if (tile == 2) 
			//{
				///*TODO deallocate memory for tile*/
				//return;
			//}
		//
			//moveDirection = Direction;
			//moveToNextTile = true;
		//}
	//}
}