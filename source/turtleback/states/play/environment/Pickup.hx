package turtleback.states.play.environment;

import flixel.FlxSprite;

/**
 * The fields required for instantion of a pickup.
 */
typedef PickupData = {
	var type:String;
	var image:String;
	var x:Float;
	var y:Float;
}

/**
 * A collectable item that the player can pick up.
 *
 * The relevant additional field is a typed which can be used
 * to identify the item as it is added to the player's inventory.
 */
class Pickup extends FlxSprite
{
	/** The item type for this pickup. */
	public var type(default, null):String;
	
	/**
	 * Constructs a new pickup from a type, image, and position information.
	 *
	 * @param	type The pickup type of the item.
	 * @param	x The x position of the item.
	 * @param	y	The y position of the item.
	 * @param	image	The path to the image for the item.
	 */
	public function new(type:String, x:Float = 0, y:Float = 0, image:String)
	{
		this.type = type;
		
		super(x, y, image);
		
		moves = false;
	}
}
