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


/*
 * TODO
 * 
 * -make enemies move tile-by-tile
 * -make enemies hide in shadows when they see you
 * -make enemies run when you get close to them
 * 
*/

class Enemy extends FlxSprite
{
	public var speed:Float = 160;
	public var etype(default, null):Int;
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	public var coinPos(default, null):FlxPoint;
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
		playerPos = FlxPoint.get();
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
	
	public function idle():Void
	{
		trace("idle");
		if (seesPlayer)
		{
			//TODO hide
			_brain.activeState = idle;
			velocity.x = velocity.y = 0;
		}
		else
		{
			_brain.activeState = chase;
		}
		
		//else if (_idleTmr <= 0)
		//{
			//if (FlxRandom.chanceRoll(1))
			//{
				//_moveDir = -1;
				//velocity.x = velocity.y = 0;
			//}
			//else
			//{
				//_moveDir = FlxRandom.intRanged(0, 8) * 45;
				//FlxAngle.rotatePoint(speed * .5, 0, 0, 0, _moveDir, velocity);
				//
			//}
			//_idleTmr = FlxRandom.intRanged(1, 4);			
		//}
		//else
			//_idleTmr -= FlxG.elapsed;
		
	}
	
	public function chase():Void
	{
		trace("chase");
		if (seesPlayer)
		{
			//TODO hide
			_brain.activeState = idle;
		}
		else
		{
		//if (!seesPlayer)
		//{
			//_brain.activeState = idle;
		//}
		//else
		//{
			FlxVelocity.moveTowardsPoint(this, coinPos, Std.int(speed));
		//}
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
}