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

import turtleback.states.cutscene.CutsceneState;

import turtleback.states.play.environment.Level;
import turtleback.states.play.environment.Level.LevelData;
import turtleback.states.play.player.Player;

import turtleback.states.play.ui.InventoryUI;

/**
 * The play state for this game.
 */
class PlayState extends FlxState
{
	private var m_dataPath:String = "assets/data/levels/dev.json";
	
	private var m_cameraTarget:FlxObjectFollower;
	private var m_player:Player;
	
	public var inventoryUI:InventoryUI;
	
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
			FlxG.width / 2,
			FlxG.height / 2);
		add(m_cameraTarget);
		FlxG.camera.follow(m_cameraTarget.anchor, LOCKON, 1);
		
		inventoryUI = new InventoryUI();
		add(inventoryUI);
		
		m_player.inventory.connectUI(inventoryUI);
		m_player.inventory.addItemType("mushroom", "assets/images/mushroom-tmp.png");
		m_player.goals.addGoal("mushroom", 3);
		
		super.create();
	}
	/**
	 * Updates all FlxObjects in this state.
	 * @param	dt	The time that has passed since the last update
	 */
	override public function update(dt:Float)
	{
		super.update(dt);
		
		// Ensure that the player does not pass beyond the stage's boundaries.
		FlxG.collide(m_player, m_level.boundaries);
		
		if (FlxG.keys.anyPressed([Z]))
		{
			FlxG.overlap(m_player, m_level.pickups, pickupCallback);
		}
	}
	/**
	 * Loads the level that is specified in the data file.
	 */
	private function loadLevel():Void
	{
		if (Assets.exists(m_dataPath, AssetType.TEXT))
		{
			m_level = new Level(Json.parse(Assets.getText(m_dataPath)));
		}
		else
		{
			var data:LevelData = {
				boundaries: [],
				background: {type:"missing", data:null},
				pickups: []
			}
			m_level = new Level(data);
		}
		
		add(m_level);
		FlxG.worldBounds.union(m_level.bounds);
	}
	/**
	 * Processes the player picking up an object.
	 *
	 * Called when the player presses the Pick up button and overlaps with a
	 * pick-up object.
	 *
	 * @param	player	The player, passed in as the first overlapping object
	 * @param	pickup	The pickup, passed in as the second overlapping object
	 */
	 private function pickupCallback(player:Dynamic, pickup:Dynamic):Void
	 {
		 pickup.kill();
		 m_player.inventory.addItem(pickup.type);
		 
		 if (m_player.goals.met)
		 {
			 FlxG.switchState(new CutsceneState(true));
		 }
	 }
}
