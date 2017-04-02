package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
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
	background: BackgroundData
}

class Level extends FlxGroup
{
	public var background(default, null):FlxBasic;
	public var boundaries(default, null):FlxGroup;
	
	public var bounds(default, null):FlxRect;
	
	public function new(levelData:LevelData)
	{
		super();
		
		bounds = new FlxRect();
		boundaries = new FlxGroup();
		add(boundaries);
		
		loadBoundaries(levelData.boundaries);
		
		loadBackground(levelData.background);
		add(background);
	}
	
	public function addBoundary(x:Int, y:Int, width:Int, height:Int)
	{
		if (width < 0)
		{
			x += width;
			width = -width;
		}
		if (height < 0)
		{
			y += height;
			height = -height;
		}
		
		var object = new FlxObject(x, y, width, height);
		object.immovable = true;
		boundaries.add(object);
		
		bounds.union(new FlxRect(x, y, width, height));
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
		}
	}
}
