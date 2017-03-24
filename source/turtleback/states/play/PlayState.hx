package turtleback.states.play;

import haxe.Json;
import openfl.Assets;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.group.FlxGroup;

import turtleback.states.play.actors.Player;
import turtleback.states.play.environment.Level;

class PlayState extends FlxState
{
	private var _dataPath:String = "assets/data/levels/dev.json";
	
	private var _cameraTarget:FlxObjectFollower;
	private var _player:Player;
	
	private var _level:Level;
	
	override public function create():Void
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		loadLevel();
		
		_player = new Player();
		_player.setPosition(20, FlxG.height - 20 - _player.height);
		add(_player);
		
		_cameraTarget = new FlxObjectFollower(_player,
			(FlxG.width - _player.width) / 2,
			(FlxG.height - _player.height),
			FlxG.width / 2, FlxG.height / 2);
		add(_cameraTarget);
		
		FlxG.camera.follow(_cameraTarget.anchor, LOCKON, 1);
		
		super.create();
	}
	
	override public function update(dt:Float)
	{
		super.update(dt);
		
		FlxG.collide(_player, _level.boundaries);
	}
	
	private function loadLevel():Void
	{
		if (Assets.exists(_dataPath, AssetType.TEXT))
		{
			var data:Dynamic = Json.parse(Assets.getText(_dataPath));
			_level = new Level(data.boundaries, data.background);
		}
		else
		{
			_level = new Level([],{type:"missing", data:null});
		}
		
		add(_level);
		FlxG.worldBounds.copyFrom(_level.bounds);
	}
}
