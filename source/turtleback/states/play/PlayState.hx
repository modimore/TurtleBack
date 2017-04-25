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
import turtleback.states.play.environment.Pickup;
import turtleback.states.play.environment.Pickup.PickupData;
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
	private var m_pickups:FlxGroup;
	
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
		
		m_pickups = new FlxGroup();
		
		// Set up the player.
		m_player = new Player();
		m_player.setPosition(20, FlxG.height - 20 - m_player.height);
		
		loadLevel();
		
		// Set up the target that the camera will follow.
		m_cameraTarget = new FlxObjectFollower(m_player,
			(FlxG.width - m_player.width) / 2,
			(FlxG.height - m_player.height),
			FlxG.width / 2,
			FlxG.height / 2);
		FlxG.camera.follow(m_cameraTarget.anchor, LOCKON, 1);
		
		inventoryUI = new InventoryUI();
		
		m_player.inventory.connectUI(inventoryUI);
		m_player.inventory.addItemType("mushroom", "assets/images/mushroom-tmp.png");
		
		add(m_level);
		add(m_pickups);
		add(m_player);
		add(inventoryUI);
		add(m_cameraTarget);
		
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
			FlxG.overlap(m_player, m_pickups, pickupCallback);
		}
	}
	/**
	 * Loads the level that is specified in the data file.
	 */
	private function loadLevel():Void
	{
		if (Assets.exists(m_dataPath, AssetType.TEXT))
		{
			var data = Json.parse(Assets.getText(m_dataPath));
			m_level = new Level(data.level);
			
			loadPickups(data.pickups);
			
			var quotas:Array<Dynamic> = data.quotas;
			for (quota in quotas)
			{
				m_player.goals.addGoal(quota.type, quota.quantity);
			}
		}
		else
		{
			var data:LevelData = {
				boundaries: [],
				background: {type:"missing", data:null},
			}
			m_level = new Level(data);
		}
		
		FlxG.worldBounds.union(m_level.bounds);
	}
	/**
	 * Loads the pickups for the level.
	 *
	 * Currently each pickup is a static image placed at a known position.
	 *
	 * @param	data	An array of grouped item types, image names, and positions.
	 */
	private function loadPickups(data:Array<PickupData>):Void
	{
		for (item in data)
		{
			var pickup = new Pickup(item.type, item.x, item.y, item.image);
			m_pickups.add(pickup);
		}
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
