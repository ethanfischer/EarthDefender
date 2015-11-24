package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _txtTitle:FlxText;
	private var _btnOptions:FlxButton;
	private var _btnPlay:FlxButton;
	#if desktop
	private var _btnExit:FlxButton;
	#end
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if (FlxG.sound.music == null) // don't restart the music if it's alredy playing
		{
			#if flash
			//FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
			#else
			//FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__ogg, 1, true);
			#end
		}
		
		_txtTitle = new FlxText(0, 20, 0, "Earth Defender\n (Prototype) \n\n\n\n\n\nPress Spacebar", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		//_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		//_btnPlay.setSize(100, 50);
		//_btnPlay.x = (FlxG.width / 2) - _btnPlay.width/2;
		//_btnPlay.y = FlxG.height - _btnPlay.height * 5;
		//add(_btnPlay);
		
		
		
		#if desktop
		_btnExit = new FlxButton(FlxG.width - 28, 8, "X", clickExit);
		_btnExit.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(_btnExit);
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	override public function update():Void
	{
		
		if (FlxG.keys.anyPressed(["SPACE", "ENTER"])) clickPlay();
	}
	
	

	
	#if desktop
	private function clickExit():Void
	{
		System.exit(0);
	}
	#end
	
	private function clickPlay():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
			FlxG.switchState(new PlayState());
		});
	}
	
	private function clickOptions():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
			FlxG.switchState(new OptionsState());
		});
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
		_btnOptions = FlxDestroyUtil.destroy(_btnOptions);
		#if desktop
		_btnExit = FlxDestroyUtil.destroy(_btnExit);
		#end
	}
}