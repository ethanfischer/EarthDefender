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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																											//
//								IMPORTED GRID MOVEMENT CODE													//
//																											//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
enum MoveDirection
{
	UPTAP;
	DOWNTAP;
	LEFTTAP;
	RIGHTTAP;
	UPHOLD;
	DOWNHOLD;
	LEFTHOLD;
	RIGHTHOLD;
	
	UPRIGHTHOLD;
	UPLEFTHOLD;
	DOWNRIGHTHOLD;
	DOWNLEFTHOLD;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																											//
//														END													//
//																											//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Player extends FlxSprite
{
	private var _sndStep:FlxSound;
	
		
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//																											//
	//								IMPORTED GRID MOVEMENT CODE													//
	//																											//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * How big the tiles of the tilemap are.
	 */
	private static inline var TILE_SIZE:Int = 16;
	
	
	/**
	 * How many pixels to move each frame. Has to be a divider of TILE_SIZE 
	 * to work as expected (move one block at a time), because we use the
	 * modulo-operator to check whether the next block has been reached.
	 */
	//HOlD_MOVEMENT should only kick in after you've held the key for a given amount of time
	private static var HOLD_MOVEMENT_THRESHOLD:Float = 0.06;
	private var HOLD_DURATION:Float = 0; //
	private static inline var HOLD_MOVEMENT_SPEED:Int = 4;
	private static inline var TAP_MOVEMENT_SPEED:Int = 4;
	
	private var _upTap:Bool = false;
	private var _downTap:Bool = false;
	private var _leftTap:Bool = false;
	private var _rightTap:Bool = false;
	
	private var _upHold:Bool = false;
	private var _downHold:Bool = false;
	private var _leftHold:Bool = false;
	private var _rightHold:Bool = false;
	
	private var _upRightHold:Bool = false;
	private var _upLeftHold:Bool = false;
	private var _downRightHold:Bool = false;
	private var _downLeftHold:Bool = false;
	
	
	private var _mWalls:FlxTilemap;
	private var _playerPos:FlxPoint = new FlxPoint(0, 0);

	
	
	/**
	 * Flag used to check if char is moving.
	 */ 
	public var moveToNextTile:Bool;
	/**
	 * Var used to hold moving direction.
	 */ 
	private var moveDirection:MoveDirection;
	
	#if mobile
	private var _virtualPad:FlxVirtualPad;
	#end
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//																											//
	//														END													//
	//																											//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	public function new(X:Float=0, Y:Float=0, i_mWalls:FlxTilemap) 
	{
		super(X, Y);
		
		// Make the player graphic.
		makeGraphic(TILE_SIZE, TILE_SIZE, 0xffc04040);
		
		_mWalls = i_mWalls;
		
		// IMPORTED GRID MOVEMENT CODE //
		#if mobile
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		#end
		//				END			   //
	}
	
	private function movement():Void
	{
		
		
		#if !FLX_NO_KEYBOARD
		_upTap = (FlxG.keys.anyJustReleased(["UP", "W"]) && HOLD_DURATION < HOLD_MOVEMENT_THRESHOLD);
		_downTap = (FlxG.keys.anyJustReleased(["DOWN", "S"]) && HOLD_DURATION < HOLD_MOVEMENT_THRESHOLD);
		_leftTap = (FlxG.keys.anyJustReleased(["LEFT", "A"]) && HOLD_DURATION < HOLD_MOVEMENT_THRESHOLD);
		_rightTap = (FlxG.keys.anyJustReleased(["RIGHT", "D"]) && HOLD_DURATION < HOLD_MOVEMENT_THRESHOLD);
		
		_upHold = FlxG.keys.anyPressed(["UP", "W"]);
		_downHold = FlxG.keys.anyPressed(["DOWN", "S"]);
		_leftHold = FlxG.keys.anyPressed(["LEFT", "A"]);
		_rightHold = FlxG.keys.anyPressed(["RIGHT", "D"]);
		
		//reset hold duration when no direction keys are pressed
		if (!FlxG.keys.anyPressed(["UP", "W", "DOWN", "S", "LEFT", "A", "RIGHT", "D"])){
			HOLD_DURATION = 0;
		}
		
		//keep track of how long player holds buttons
		if (_upHold || _downHold || _leftHold || _rightHold)
		{
			HOLD_DURATION += FlxG.elapsed;
		
			//trace("HOLD DURATION: " + HOLD_DURATION);
		
		}
		
		#end
		
		#if mobile
		_upTap = _upTap || PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		_downTap = _downTap || PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		_leftTap  = _leftTap || PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_rightTap = _rightTap || PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		_upHold = _upHold || PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;				
		_downHold = _downHold || PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;		
		_leftHold  = _leftHold || PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_rightHold = _rightHold || PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		
		#end
		
		if (_upHold && _downHold)
			_upHold = _downHold = false;
		if (_leftHold && _rightHold)
			_leftHold = _rightHold = false;
		
		if ( _upTap || _downTap || _leftTap || _rightTap || _upHold || _downHold || _leftHold || _rightHold )
		{
			
			//						IMPORTED and tampered with			//
			//		key listening code from grid based movement			//
			if (_downTap) {
				moveTo(MoveDirection.DOWNTAP);
			} else if (_upTap) {
				moveTo(MoveDirection.UPTAP);
			} else if (_leftTap) {
				moveTo(MoveDirection.LEFTTAP);
			} else if (_rightTap) {
				moveTo(MoveDirection.RIGHTTAP);
			}
			
			if (HOLD_DURATION > HOLD_MOVEMENT_THRESHOLD)
			{
				/*diagonal*/
				if (_upHold && _rightHold) moveTo(MoveDirection.UPRIGHTHOLD);
				else if (_upHold && _leftHold) moveTo(MoveDirection.UPLEFTHOLD);
				else if (_downHold && _rightHold) moveTo(MoveDirection.DOWNRIGHTHOLD);
				else if (_downHold && _leftHold) moveTo(MoveDirection.DOWNLEFTHOLD);
				
				/*cardinal*/
				else if(_upHold) moveTo(MoveDirection.UPHOLD);
				else if (_downHold) moveTo(MoveDirection.DOWNHOLD);
				else if (_leftHold) moveTo(MoveDirection.LEFTHOLD);
				else if (_rightHold) moveTo(MoveDirection.RIGHTHOLD);
			}
			//															//
			//															//
			
		}
		
		if (true) //TODO
		{
			//movement code (not functions)
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			//																											//
			//								IMPORTED GRID MOVEMENT CODE													//
			//																											//
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			// Move the player to the next block
				if (moveToNextTile)
				{
					switch (moveDirection)
					{
						case UPTAP:
							y -= TAP_MOVEMENT_SPEED;
						case DOWNTAP:
							y += TAP_MOVEMENT_SPEED;
						case LEFTTAP:
							x -= TAP_MOVEMENT_SPEED;
						case RIGHTTAP:
							x += TAP_MOVEMENT_SPEED;
						case UPHOLD:
							y -= HOLD_MOVEMENT_SPEED;
						case DOWNHOLD:
							y += HOLD_MOVEMENT_SPEED;
						case LEFTHOLD:
							x -= HOLD_MOVEMENT_SPEED;
						case RIGHTHOLD:
							x += HOLD_MOVEMENT_SPEED;	
							
						/*diagonal*/	
						case UPRIGHTHOLD:
							y -= HOLD_MOVEMENT_SPEED;
							x += HOLD_MOVEMENT_SPEED;
						case UPLEFTHOLD:
							y -= HOLD_MOVEMENT_SPEED;
							x -= HOLD_MOVEMENT_SPEED;
						case DOWNRIGHTHOLD:
							y += HOLD_MOVEMENT_SPEED;
							x += HOLD_MOVEMENT_SPEED;
						case DOWNLEFTHOLD:
							y += HOLD_MOVEMENT_SPEED;
							x -= HOLD_MOVEMENT_SPEED;	
					}
				}
				
				// Check if the player has now reached the next block
				if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
				{
					moveToNextTile = false;
				}
					
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//																											//
				//														END													//
				//																											//
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//												IMPORTED GRID MOVEMENT CODE												//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function moveTo(Direction:MoveDirection):Void //TODO
	{
		/*Only change direction if not already moving*/
		if (!moveToNextTile)
		{
			var tile:Int;
			
			function diagonalCheck(_d1:MoveDirection, _d2:MoveDirection):Int
			{
				var _dTile1:Int = 99;
				var _dTile2:Int = 99;
				
				//function switchCheck(_d:MoveDirection, _dTile:Int):Void
				//{
					//switch (_d)
					//{
						//case UPHOLD:	
							//_dTile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
						//case DOWNHOLD:
							//_dTile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
						//case RIGHTHOLD:
							//_dTile = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						//case LEFTHOLD:
							//_dTile = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						//default:
							//return;
					//}
				//}
				
				//switchCheck(_d1, _dTile1);
				//switchCheck(_d2, _dTile2);
				
				switch (_d1)
					{
						case UPHOLD:	
							_dTile1 = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
						case DOWNHOLD:
							_dTile1 = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
						case RIGHTHOLD:
							_dTile1 = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						case LEFTHOLD:
							_dTile1 = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						default:
							return 1; //returning 1 exits the moveTo function
					}
				switch (_d2)
					{
						case UPHOLD:	
							_dTile2 = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
						case DOWNHOLD:
							_dTile2 = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
						case RIGHTHOLD:
							_dTile2 = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						case LEFTHOLD:
							_dTile2 = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
						default:
							return 1;
					}	
				
				if (_dTile1 != 2 && _dTile2 != 2) return 1; //if neither first nor second tile are colliable, return 1 (1 is used where diagCheck is called to return)
				else if (_dTile1 != 2) Direction = _d1; //if first direction isn't collidable, go up 
				else if (_dTile2 != 2) Direction = _d2;
				
				return 0;
			}
			
			/*Check next tile relative to player's current tile and movement direction. If solid, don't allow movement
			get tile moving to, based on players current tile and movedirection*/
			
			/*cardinal*/
			if (Direction == MoveDirection.UPTAP || Direction ==  MoveDirection.UPHOLD)
			{
				tile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
				if (tile == 2) return;
			} 
			else if (Direction == MoveDirection.DOWNTAP || Direction == MoveDirection.DOWNHOLD)
			{
				tile = _mWalls.getTile(Std.int(x / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
				if (tile == 2) return;
			} 
			else if (Direction == MoveDirection.LEFTTAP || Direction == MoveDirection.LEFTHOLD)
			{
				tile = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
				if (tile == 2) return;
			} 
			else if (Direction == MoveDirection.RIGHTTAP || Direction == MoveDirection.RIGHTHOLD)
			{
				tile = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int(y / TILE_SIZE));
				if (tile == 2) return;
			} 
			
			/*diagonal*/
			else if (Direction ==  MoveDirection.UPRIGHTHOLD)
			{
				tile = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
				if (tile == 2) 
				{
					if (diagonalCheck(UPHOLD, RIGHTHOLD) == 1) return; //call diagonalCheck and if it returns 1, exit this function
				}
			} else if (Direction == MoveDirection.UPLEFTHOLD)
			{
				tile = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int((y - TILE_SIZE) / TILE_SIZE));
				if (tile == 2) 
				{
					if (diagonalCheck(UPHOLD, LEFTHOLD) == 1) return;
				}
			} else if (Direction == MoveDirection.DOWNRIGHTHOLD)
			{
				tile = _mWalls.getTile(Std.int((x + TILE_SIZE) / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
				if (tile == 2) 
				{
					if(diagonalCheck(DOWNHOLD, RIGHTHOLD) == 1) return;
				}
			} else
			{
				tile = _mWalls.getTile(Std.int((x - TILE_SIZE) / TILE_SIZE), Std.int((y + TILE_SIZE) / TILE_SIZE));
				if (tile == 2) 
				{
					if (diagonalCheck(DOWNHOLD, LEFTHOLD) == 1) return;
				}
			} 
				
			moveDirection = Direction;
			moveToNextTile = true;
			
			
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//												END																		//
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	override public function update():Void 
	{
		movement(); //movement is a TurnBasedRPG function
		super.update();
		_playerPos.x = x;
		_playerPos.y = y;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_sndStep = FlxDestroyUtil.destroy(_sndStep);
	}
	
	public function getPlayerPos():FlxPoint
	{
		return _playerPos;
	}
	

	
}