package turtleback.states.shared;

import haxe.Json;
import openfl.Assets;

import flixel.FlxSprite;

/**
 * A collection of attributes used to add an animation to a FlxSprite.
 */
typedef FlixelAnimationData = {
	var name:String;
	var frames:Array<Int>;
	@:optional var framerate:Int;
	@:optional var looped:Bool;
	@:optional var flipX:Bool;
	@:optional var flipY:Bool;
}

/**
 * The items expected in an entity's data file.
 */
typedef TBEntityData = {
	var frame_width:Int;
	var frame_height:Int;
	var animations:Array<FlixelAnimationData>;
}

/**
 * A FlxSprite that inializes itself based on data linked to its ID.
 */
class TBEntity extends FlxSprite
{
	/**
	 * Constructs an entity from its ID and starting position.
	 * @param	id	The string ID of the entity.
	 * @param	x	The initial x coordinate of the sprite.
	 * @param	y	The inital y coordinate of the sprite.
	 */
	public function new(id:String, x:Float = 0, y:Float = 0)
	{
		// Call the superclass constructor.
		super(x, y);
		
		// Paths to the resources for this entity.
		var dataFilePath:String = 'assets/data/entities/${id}.json';
		var spritesheetPath = 'assets/images/entities/${id}.png';
		
		if (Assets.exists(dataFilePath))
		{
			// Load the graphic and add animations for the entity based on the
			// contents of its corresponding data file.
			var data:TBEntityData = Json.parse(Assets.getText(dataFilePath));
			
			loadGraphic(spritesheetPath, true, data.frame_width, data.frame_height);
			
			for (anim in data.animations)
			{
				if (anim.framerate == null)
					anim.framerate = 6;
				if (anim.looped == null)
					anim.looped = false;
				if (anim.flipX == null)
					anim.flipX = false;
				if (anim.flipY == null)
					anim.flipY = false;
				
				animation.add(
					anim.name, anim.frames, anim.framerate,
					anim.looped, anim.flipX, anim.flipY);
			}
		}
		else
		{
			loadGraphic(spritesheetPath);
		}
	}
}
