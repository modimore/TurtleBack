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
	private var m_dataPath:String = "assets/data/levels/dev.json";
	
	private var m_cameraTarget:FlxObjectFollower;
	private var m_player:Player;
	
	private var m_level:Level;
	/**
	 * Creates all FlxObject children when added to the game root.
	 */
	override public function create():Void
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		loadLevel();
		
		// Set up the player.
		m_player = new Player();
		m_player.setPosition(20, FlxG.height - 20 - m_player.height);
		add(m_player);
		
		// Set up the target that the camera will follow.
		m_cameraTarget = new FlxObjectFollower(m_player,
			(FlxG.width - m_player.width) / 2,
			(FlxG.height - m_player.height),
			FlxG.width / 2, FlxG.height / 2);
		add(m_cameraTarget);
		
		FlxG.camera.follow(m_cameraTarget.anchor, LOCKON, 1);
		
		super.create();
	}
	/**
	 * Updates all FlxObjects in this state.
	 * @param	dt	The time that has passed since the last update
	 */
	override public function update(dt:Float)
	{
		super.update(dt);
		
		FlxG.collide(m_player, m_level.boundaries);
	}
	/**
	 * Loads the level that is specified in the data file.
	 */
	private function loadLevel():Void
	{
		if (Assets.exists(m_dataPath, AssetType.TEXT))
		{
			var data:Dynamic = Json.parse(Assets.getText(m_dataPath));
			m_level = new Level(data.boundaries, data.background);
		}
		else
		{
			m_level = new Level([],{type:"missing", data:null});
		}
		
		add(m_level);
		FlxG.worldBounds.copyFrom(m_level.bounds);
	}
}
