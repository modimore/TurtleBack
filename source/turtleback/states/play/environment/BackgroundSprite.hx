package turtleback.states.play.environment;

import flixel.FlxSprite;

/**
 * A simple sprite intended for use as a background image.
 *
 * This is a regular FlxSprite that upon construction is set not to
 * move or collide with anything.
 */
class BackgroundSprite extends FlxSprite
{
	/**
	 * Creates a sprite and sets it to be immobile and not to process
	 * collisions on any side.
	 *
	 * @param	x	The x-position of the sprite.
	 * @param	y	The y-position of the sprite.
	 * @param	image	The path to the image this sprite displays.
	 */
	public function new(x:Float, y:Float, image:String)
	{
		super(x, y, image);
		solid = false;
		moves = false;
	}
}
