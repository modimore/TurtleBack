package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

/**
 * The data fields required by each level tile.
 */
typedef TileData = {
	x:Float,
	y:Float,
	image:String,
	groundHeight:Float
}

/**
 * A single tile in the level.
 *
 * One of these contains a background and a ground segment.
 */
class LevelTile extends FlxGroup
{
	private var m_bg:BackgroundSprite;
	private var m_groundObject:FlxObject;
	
	/**
	 * Constucts a new tile from an image and some ground data.
	 * @param	data	The data to construct the tile with.
	 */
	public function new(data:TileData)
	{
		super();
		
		m_bg = new BackgroundSprite(data.x, data.y, data.image);
		add(m_bg);
		
		m_groundObject = new FlxObject(data.x, data.groundHeight, m_bg.width, 1);
		m_groundObject.immovable = true;
		m_groundObject.moves = false;
		add(m_groundObject);
	}
}
