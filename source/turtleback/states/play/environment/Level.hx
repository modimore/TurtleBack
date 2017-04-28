package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

import turtleback.states.play.environment.LevelTile.TileData;

/**
 * The coordinates and dimensions of a rectangle.
 */
typedef Rectangle = {
	x:Int,
	y:Int,
	width:Int,
	height:Int
}
/**
 * Definition of the data required to create a background.
 */
typedef BackgroundData = {
	type:String,
	data:Dynamic
}
/**
 * Definition of the fields required in the level data.
 */
typedef LevelData = {
	boundaries:Array<Rectangle>,
	tiles:Array<TileData>
}

/**
 * A FlxGroup containing most of the components of a gameplay level.
 */
class Level extends FlxGroup
{
	public var bounds(default, null):FlxRect;
	public var boundaries(default, null):FlxGroup;
	public var tiles(default, null):FlxGroup;
	
	/**
	 * Constructs a level from an input object.
	 * @param	levelData	A description of the components of a specific level.
	 */
	public function new(levelData:LevelData)
	{
		super();
		
		bounds = FlxRect.get();
		boundaries = new FlxGroup();
		tiles = new FlxGroup();
		
		loadTiles(levelData.tiles);
		add(tiles);
		
		loadBoundaries(levelData.boundaries);
		add(boundaries);
	}
	/**
	 * Creates the level boundaries from provided rectangle coordinates.
	 *
	 * Each rectangle becomes an immovable FlxObject at the position specified
	 * and with the dimensions specified. These are meant to stop the player
	 * from going off of the map.
	 *
	 * @param	data	Rectangle coordinates that will be used to create borders.
	 */
	private function loadBoundaries(data:Array<Rectangle>):Void
	{
		for (item in data)
		{
			if (item.width < 0)
			{
				item.width = -item.width;
				item.x -= item.width;
			}
			if (item.height < 0)
			{
				item.height = -item.height;
				item.y -= item.height;
			}
			
			var object = new FlxObject(item.x, item.y, item.width, item.height);
			object.immovable = true;
			boundaries.add(object);
			
			bounds.union(FlxRect.weak(item.x, item.y, item.width, item.height));
		}
	}
	/**
	 * Loads the tiles that make up this level.
	 * @param	data	An array containing the data for each tile.
	 */
	private function loadTiles(data:Array<TileData>)
	{
		for (tileData in data)
		{
			tiles.add(new LevelTile(tileData));
		}
	}
}
