package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRect;

class Earth extends FlxSprite
{
	public var tooLateBox:FlxObject;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.coin__png, false, 16, 16);
		tooLateBox = new FlxObject(X - 40, Y - 40, 80, 80);
	}
	
	override public function kill():Void 
	{
		alive = false;
		
		FlxTween.tween(this, { alpha:0, y:y - 16 }, .66, {ease:FlxEase.circOut, complete:finishKill } );
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}