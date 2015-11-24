package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxAngle;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;
using flixel.util.FlxSpriteUtil;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

/*
 * TODO
 * 
 * -make enemies smarter:
 * 		-hide in shadows
 * 		-wait until you are away from the globe
 * 
 * 
*/

class Enemy extends FlxSprite
{
	public var _speed:Float = 100;
	public var etype(default, null):Int;
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	//public var coinPos(default, null):FlxPoint;
	private var _going4itFlag:Bool = false;
	private var _player:Player;
	private var _htspFlag:Bool = false;
	
	private var _pathSetter:FlxPath = new FlxPath(); //I guess a FlxPath object makes your object follow a path. Seems backwards to me, but whatever

	
	//corners of the map used for moving away from the player
	private var _UL:FlxPoint; //upleft
	private var _UR:FlxPoint; //upright
	private var _DL:FlxPoint; //downleft
	private var _DR:FlxPoint; //downright
	
	private var _path:Array<FlxPoint> = new Array();
	private var _chaseFlag:Bool = false;
	private var _goal:FlxPoint = new FlxPoint( -100, -100); //intialize at this so its not null. Goal is updated each time you make a new path
	
	private var _go4itTimer:Float = 0;
	private var _closeCallFlag:Bool = false; //once the enemy is going4it, once they're on screen they should go a little faster, but only update speed once
	//private var _visionBox:FlxRect;

	
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
		
		//hard-coded for now, TODO use _spnPts
		_UL = new FlxPoint(32, 32);
		_UR = new FlxPoint(1456, 32);
		_DL = new FlxPoint(32, 1456);
		_DR = new FlxPoint(1456, 1456);
		
		//coinPos = FlxPoint.get();

		//_sndStep = FlxG.sound.load(AssetPaths.step__wav,.4);
		//_sndStep.proximity(x,y,FlxG.camera.target, FlxG.width *.6);
	}
	
	override public function update():Void 
	{
		//if (isFlickering())
			//return;
		_brain.update();
		super.update();
		
		if (overlaps(Registry._enmHotspot)) enmTouchHotspot();
		
	
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
				////FlxAngle.rotatePoint(spe^&^&ed * .5, 0, 0, 0, _moveDir, velocity);
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
		
		if (seesPlayer && !_going4itFlag) //TODO if in shadows, be idle. Otherwise, flee! FOr now, if sees player, flee!
		{
			//TODO hide in shadows
			_brain.activeState = flee;
			flee();
		}
		else
		{	
			if (_going4itFlag)
			{
				if (isOnScreen() && !_closeCallFlag) //TODO: needs to update 
				{
					_speed = 110; //this difference in _speed makes for more 'close calls' and thus more excitement hopefully
					_goal = new FlxPoint(Registry._earthPos.x, Registry._earthPos.y + 1); //have to reset goal so it will update followpath with new speed
					_closeCallFlag = true;
				}
				else _speed = 80; //slightly slower than their straif/retreat _speed	
			}			
			_brain.activeState = chase;
			followPath(Registry._earthPos);
		}
	}
	
	private function enmTouchHotspot():Void
	{
		//if (!FlxG.keys.anyPressed(["g"])) FlxG.camera.follow(this); //For testing purposes, to see where they are when they contact the perimeter
		
		var d:Float = FlxMath.getDistance(new FlxPoint(Registry._player.x, Registry._player.y), new FlxPoint(x, y));
		//trace(d);
		
		if (_go4itTimer < 4 && !_going4itFlag) hide();
		
		if (d > 1000) //if player is sufficiently far enough away 
		{
			_go4itTimer += FlxG.elapsed; //count how long they are far enough away
			if (_go4itTimer > 3 && !_going4itFlag)
			{
				go4it();
			}
		}
		else _go4itTimer = 0; //if player comes in range, reset the go4ittimer
		
	
		
	}
	
	public function flee():Void
	{
		if (seesPlayer && !_going4itFlag)
		{
			_brain.activeState = flee;
			_speed = 100;
			moveAwayFromPlayer();
		} else
		{
			_brain.activeState = chase;
			chase();
		}
	}
	
	public function hide():Void
	{
		//TODO, make them seek the nearest shadow and wait there
		//for now, wait at the perimeter
		if (seesPlayer && !_going4itFlag) 
		{
			flee();
			_brain.activeState = flee;
		}
		else
		{
			_brain.activeState = hide;
			_pathSetter.cancel(); //stop from moving
			_goal = new FlxPoint(x, y); //have to set goal to something so when chase is called again, it will follow the path again
		}
	}
	
	private function followPath(i_goal:FlxPoint):Void
	{
		if (i_goal != _goal) //if you've already established a path, don't do it again until it's new path (new goal)
		{
			_goal = i_goal;
			_path = Registry._mWalls.findPath(new FlxPoint(x,y), _goal);
			
			if (_path != null)
			{	
				_pathSetter.start(this, _path, _speed);
			}
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
			
			//TODO replace with pathfinding
			followPath(_UL);
		} 
		
		//upperright of player
		else if (x >= _player.x && y < _player.y) { 
			followPath(_UR);
		} 
		
		//downleft of player
		else if (x <= _player.x && y > _player.y) { 
			followPath(_DL);
		} 
		
		//downright of player
		else if (x > _player.x &&  y > _player.y) { 
			followPath(_DR);
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
		//_going4itFlag = false;
		super.destroy();
		
		//_sndStep = FlxDestroyUtil.destroy(_sndStep);
	}
	
	public function go4it():Void
	{
		FlxG.camera.shake(0.02, 0.2);
		Registry._sndAlert.play();
		_going4itFlag = true;
		chase();
	}
	
	public function getHtspFlag():Bool //get hotspot flag
	{
		return _htspFlag;
	}
	public function setHtspFlag(b:Bool):Void //hotspot flag
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