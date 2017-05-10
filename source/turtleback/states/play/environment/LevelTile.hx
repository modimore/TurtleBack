package turtleback.states.play.environment;

import haxe.Json;
import openfl.Assets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

import turtleback.states.play.environment.GroundObject;
import turtleback.states.play.environment.GroundObject.GroundData;

/**
 * The data fields required by each level tile.
 */
typedef TileInstanceData = {
	type:String,
	x:Float,
	y:Float
}

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
	 * Constucts a new tile from an image and some ground data.
	 * @param	data	The data to construct the tile with.
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
