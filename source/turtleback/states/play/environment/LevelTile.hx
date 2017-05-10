package turtleback.states.play.environment;

import haxe.Json;
import openfl.Assets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

import turtleback.states.play.environment.GroundObject;
import turtleback.states.play.environment.GroundObject.GroundData;

/**
 * The info required to instantiate a level tile.
 */
typedef TileInstanceData = {
	var type:String;
	var x:Float;
	var y:Float;
}

/**
 * The fields required in the data about a tile type.
 */
typedef TileTypeData = {
	var ground:GroundData;
}

/**
 * A single tile in the level.
 *
 * One of these contains a background and a ground segment.
 */
class LevelTile extends FlxGroup
{
	private var m_bg:BackgroundSprite;
	private var m_groundObject:GroundObject;
	
	/**
	 * Constucts a new tile from position data and a tile type id.
	 * @param	type_id	The id for the type of tile to use.
	 * @param	x	The x position of the tile.
	 * @param	y	The y position of the tile.
	 */
	public function new(type_id:String, x:Float, y:Float)
	{
		super();
		
		var imagePath = 'assets/images/backgrounds/${type_id}.png';
		var dataPath = 'assets/data/level_tiles/${type_id}.json';
		
		m_bg = new BackgroundSprite(x, y, imagePath);
		
		if (Assets.exists(dataPath, AssetType.TEXT))
		{
			var tileData:TileTypeData = Json.parse(Assets.getText(dataPath));
			m_groundObject = new GroundObject(
				x, y, m_bg.width, m_bg.height, tileData.ground);
		}
		else
		{
			m_groundObject = null;
		}
		
		add(m_bg);
		add(m_groundObject);
	}
}
