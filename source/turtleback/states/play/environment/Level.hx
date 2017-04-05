package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

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
	background: BackgroundData,
	pickups: Array<Dynamic>
}

/**
 * A FlxGroup containing most of the components of a gameplay level.
 */
class Level extends FlxGroup
{
	public var background(default, null):FlxBasic;
	public var boundaries(default, null):FlxGroup;
	public var pickups(default, null):FlxGroup;
	
	public var bounds(default, null):FlxRect;
	/**
	 * Constructs a level from an input object.
	 * @param	levelData	A description of the components of a specific level.
	 */
	public function new(levelData:LevelData)
	{
		super();
		
		bounds = FlxRect.get();
		boundaries = new FlxGroup();
		loadBoundaries(levelData.boundaries);
		add(boundaries);
		
		loadBackground(levelData.background);
		add(background);
		
		pickups = new FlxGroup();
		loadPickups(levelData.pickups);
		add(pickups);
	}
	/**
	 * Creates a background for this level with the specified type and images.
	 */
	private function loadBackground(bgData:BackgroundData):Void
	{
		switch(bgData.type)
		{
			case "panel":
				background = new PanelBackground(bgData.data);
			default:
				background = new FlxBasic();
		}
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
				item.x -= item.width;
				item.width = -item.width;
			}
			if (item.height < 0)
			{
				item.y -= item.width;
				item.height = -item.height;
			}
			
			var object = new FlxObject(item.x, item.y, item.width, item.height);
			object.immovable = true;
			boundaries.add(object);
			
			bounds.union(FlxRect.weak(item.x, item.y, item.width, item.height));
		}
	}
	/**
	 * Loads the pickups for the level.
	 *
	 * Currently each pickup is a static image placed at a known position.
	 *
	 * @param	data	An array of grouped item types, image names, and positions.
	 */
	private function loadPickups(data:Array<Dynamic>):Void
	{
		for (item in data)
		{
			var pickup = new Pickup(item.type, item.x, item.y, item.image);
			pickups.add(pickup);
		}
	}
}
