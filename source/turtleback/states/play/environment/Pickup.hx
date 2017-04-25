package turtleback.states.play.environment;

import flixel.FlxSprite;

typedef PickupData = {
	type:String,
	image:String,
	x:Float,
	y:Float
}

class Pickup extends FlxSprite
{
	public var type(default, null):String;
	
	public function new(type:String, x:Float = 0, y:Float = 0, image:String)
	{
		this.type = type;
		
		super(x, y, image);
	}
}
