package turtleback.states.play.player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;


enum MotionState
{
	IDLE;
	WALKING;
	FALLING;
}

enum MotionDirection
{
	NEUTRAL;
	LEFT;
	RIGHT;
}

/**
 * The player's sprite in this game.
 */
class Player extends FlxSprite
{
	private static var WALK_SPEED:Float = 100.0;
	private static var JUMP_SPEED:Float = 200.0;
	private static var GRAVITY:Float = 250.0;
	
	private var m_motionState:MotionState;
	public var inventory:Inventory;
	
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
		
		inventory = new Inventory();
		
		m_motionState = IDLE;
	}
	/**
	 * Updates the player based on their current motion state.
	 * @param	dt	The time in seconds since the last update.
	 */
	override public function update(dt:Float):Void
	{
		var direction:MotionDirection = NEUTRAL;
		
		if (m_motionState != FALLING)
		{
			var up = FlxG.keys.anyPressed([UP, W]);
			var down = FlxG.keys.anyPressed([DOWN, S]);
			var left = FlxG.keys.anyPressed([LEFT, A]);
			var right = FlxG.keys.anyPressed([RIGHT, D]);
			
			if (up && down) { up = down = false; }
			if (left && right) { left = right = false; }
			
			if (left)
			{
				direction = LEFT;
			}
			else if (right)
			{
				direction = RIGHT;
			}
			
			if (up)
			{
				m_motionState = FALLING;
				m_jump(direction);
			}
			else if (left || right)
			{
				m_motionState = WALKING;
			}
			else
			{
				m_motionState = IDLE;
			}
		}
		
		switch(m_motionState)
		{
			case WALKING:
				m_updateWalkingHelper(direction);
			case FALLING:
				m_updateFallingHelper();
			case IDLE:
				m_updateIdleHelper();
		}
		
		super.update(dt);
	}
	/**
	 * Start the player moving in a jump arc.
	 *
	 * The arc can be straight up, or it can include a horizontal component.
	 *
	 * @param	horizontalDirection	The horizontal direction in this update cycle.
	 */
	private function m_jump(horizontalDirection:MotionDirection):Void
	{
		var velocityX:Float = 0;
		if (horizontalDirection == LEFT)
		{
			velocityX = -WALK_SPEED;
		}
		else if (horizontalDirection == RIGHT)
		{
			velocityX = WALK_SPEED;
		}
		
		velocity.set(velocityX, -JUMP_SPEED);
		acceleration.set(drag.x, GRAVITY);
	}
	/**
	 * Helps update the player in their walking state.
	 *
	 * Sets the player's velocity for this step to their walking speed in the
	 * correct direction.
	 * // TODO: Much of this functionality seems like it should belong to a state
	 * switching function rather than a specific state.
	 *
	 * @param	direction	The direction that the player will be walking in.
	 */
	private function m_updateWalkingHelper(direction:MotionDirection):Void
	{
		var velocityX:Float;
		
		switch(direction)
		{
			case LEFT:
				velocityX = -WALK_SPEED;
				facing = FlxObject.LEFT;
			case RIGHT:
				velocityX = WALK_SPEED;
				facing = FlxObject.RIGHT;
			default:
				velocityX = 0;
		}
		
		velocity.set(velocityX, 0);
		
		if (isTouching(FlxObject.LEFT | FlxObject.RIGHT))
		{
			velocity.set(0, 0);
		}
	}
	/**
	 * Helps update the player in their falling state.
	 *
	 * Checks for some collision with the player.
	 * Collisions with the bottom of the player set the falling speed to zero and
	 * the player's motion state to idle.
	 * Collisions with the top of the player just set vertical velocity to zero.
	 * The player keeps falling in this case.
	 */
	private function m_updateFallingHelper():Void
	{
		if (isTouching(FlxObject.DOWN))
		{
			acceleration.set(0, 0);
			velocity.set(velocity.x, 0);
			m_motionState = IDLE;
		}
		else if (isTouching(FlxObject.UP))
		{
			velocity.set(velocity.x, 0);
		}
	}
	/**
	 * Helps update the player in their idle state.
	 *
	 * This function keeps the player actually idle by setting velocity to zero.
	 * TODO: Really this is logic that should be handled on a state switch, not
	 * every update for this specific state.
	 */
	private function m_updateIdleHelper():Void
	{
		velocity.set(0, 0);
	}
}
