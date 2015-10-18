package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																											//
//								IMPORTED GRID MOVEMENT CODE													//
//																											//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
enum MoveDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																											//
//														END													//
//																											//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Player extends FlxSprite
{
	public var speed:Float = 200;
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
	private static inline var MOVEMENT_SPEED:Int = 2;
	
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
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		// Make the player graphic.
		makeGraphic(TILE_SIZE, TILE_SIZE, 0xffc04040);
		
		
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
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		#if !FLX_NO_KEYBOARD
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		#end
		#if mobile
		_up = _up || PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		_down = _down || PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		_left  = _left || PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_right = _right || PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		#end
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{
			
			//						IMPORTED							//
			//		key listening code from grid based movement			//
			if(_down) moveTo(MoveDirection.DOWN);
			else if (_up) moveTo(MoveDirection.UP);
			else if (_left) moveTo(MoveDirection.LEFT);
			else if (_right) moveTo(MoveDirection.RIGHT);
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
						case UP:
							y -= MOVEMENT_SPEED;
						case DOWN:
							y += MOVEMENT_SPEED;
						case LEFT:
							x -= MOVEMENT_SPEED;
						case RIGHT:
							x += MOVEMENT_SPEED;
						
						//TODO   !!!   ???	
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
	
	public function moveTo(Direction:MoveDirection):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
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
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_sndStep = FlxDestroyUtil.destroy(_sndStep);
	}
}
