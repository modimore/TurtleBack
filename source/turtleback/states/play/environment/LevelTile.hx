package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

import turtleback.states.play.environment.GroundObject;
import turtleback.states.play.environment.GroundObject.GroundData;

/**
 * The data fields required by each level tile.
 */
typedef TileData = {
	x:Float,
	y:Float,
	image:String,
	ground:GroundData
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
	public function new(data:TileData)
	{
		super();
		
		m_bg = new BackgroundSprite(data.x, data.y, data.image);
		
		m_groundObject = new GroundObject(
			m_bg.x, m_bg.y, m_bg.width, m_bg.height, data.ground);
		
		add(m_bg);
		add(m_groundObject);
	}
}
