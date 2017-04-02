package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

typedef Rectangle = {
	x:Int,
	y:Int,
	width:Int,
	height:Int
}

typedef BackgroundData = {
	type:String,
	data:Dynamic
}

typedef LevelData = {
	boundaries:Array<Rectangle>,
	background: BackgroundData,
	pickups: Array<Dynamic>
}

class Level extends FlxGroup
{
	public var background(default, null):FlxBasic;
	public var boundaries(default, null):FlxGroup;
	public var pickups(default, null):FlxGroup;
	
	public var bounds(default, null):FlxRect;
	
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
	
	private function loadPickups(data:Array<Dynamic>):Void
	{
		for (item in data)
		{
			var sprite:FlxSprite = new FlxSprite(item.x, item.y, item.image);
			pickups.add(sprite);
		}
	}
}
