package turtleback.states.play.actors;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * The player's sprite in this game.
 */
class Player extends FlxSprite
{
	private static var _SPEED:Float = 100.0;
	
	/**
	 * Constructs a player.
	 * @param	x	The player's initial x coordinate
	 * @param	y	The player's initial y coordinate.
	 */
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		
		loadGraphic("assets/images/player.png", false, 64, 256);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
	}
	/**
	 * Updates the player, moving them if needed.
	 * @param	dt	The time in seconds since the last update.
	 */
	override public function update(dt:Float):Void
	{
		var velocityX:Float = 0;
		var left:Bool;
		var right:Bool;
		
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		
		if ( left && right )
		{
			left = false;
			right = false;
		}
		
		if (left)
		{
			velocityX = -1 * _SPEED;
			facing = FlxObject.LEFT;
		}
		
		if (right)
		{
			velocityX = _SPEED;
			facing = FlxObject.RIGHT;
		}
		
		velocity.set(velocityX, 0);
		
		var velocityY:Float = 0;
		var up:Bool;
		var down:Bool;
		
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		
		if (up && down) { up = down = false; }
		
		if (up)
		{
			velocityY  = -1 * _SPEED;
		}
		if (down)
		{
			velocityY = _SPEED;
		}
		
		velocity.set(velocity.x, velocityY);
		
		if (isTouching(FlxObject.LEFT | FlxObject.RIGHT))
		{
			velocity.set(0, velocity.y);
		}
		
		super.update(dt);
	}
}
