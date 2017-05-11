package turtleback.states.play.player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import turtleback.states.shared.TBEntity;

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
class Player extends TBEntity
{
	private static var WALK_SPEED:Float = 100.0;
	private static var JUMP_SPEED:Float = 200.0;
	private static var IDLE_DRAG_X:Float = 200.0;
	private static var GRAVITY:Float = 250.0;
	
	private var m_motionState:MotionState;
	private var m_motionDirection:MotionDirection;
	
	public var inventory:Inventory;
	public var goals:Goals;
	
	/**
	 * Constructs a player.
	 * @param	x	The player's initial x coordinate
	 * @param	y	The player's initial y coordinate.
	 */
	public function new(x:Float = 0, y:Float = 0)
	{
		super("Player", x, y);
		
		inventory = new Inventory(this);
		goals = new Goals();
		
		m_motionState = IDLE;
		m_motionDirection = NEUTRAL;
		
		acceleration.set(0, GRAVITY);
	}
	/**
	 * Updates the player based on their current motion state.
	 * @param	dt	The time in seconds since the last update.
	 */
	override public function update(dt:Float):Void
	{
		if (!isTouching(FlxObject.DOWN))
		{
			m_setState(FALLING);
		}
		
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
				m_motionDirection = LEFT;
			}
			else if (right)
			{
				m_motionDirection = RIGHT;
			}
			else
			{
				m_motionDirection = NEUTRAL;
			}
			
			if (up)
			{
				m_jump();
				m_setState(FALLING);
			}
			else if (left || right)
			{
				m_setState(WALKING);
			}
			else
			{
				m_setState(IDLE);
			}
		}
		
		switch(m_motionState)
		{
			case WALKING:
				m_updateWalkingHelper();
			case FALLING:
				m_updateFallingHelper();
			case IDLE:
				m_updateIdleHelper();
		}
		
		super.update(dt);
	}
	/**
	 * Enforces that the player is in the desired motion state.
	 *
	 * If the player is already in the specified state, nothing will happen.
	 * If not, this method will perform the setup for the desired state and
	 * then switch to it.
	 *
	 * @param	nextState	The state to try to enter.
	 */
	private function m_setState(nextState:MotionState):Void
	{
		if (nextState == m_motionState)
		{
			return;
		}
		
		switch nextState
		{
			case IDLE:
				drag.set(IDLE_DRAG_X, drag.y);
				m_motionDirection = NEUTRAL;
			case WALKING:
				m_setupWalkingState();
			case FALLING:
				drag.set(0, drag.y);
		}
		
		m_motionState = nextState;
	}
	/**
	 * Start the player moving in a jump arc.
	 *
	 * The arc can be straight up, or it can include a horizontal component.
	 *
	 * @param	horizontalDirection	The horizontal direction in this update cycle.
	 */
	private function m_jump():Void
	{
		var velocityX:Float = 0;
		if (m_motionDirection == LEFT)
		{
			velocityX = -WALK_SPEED;
			facing = FlxObject.LEFT;
		}
		else if (m_motionDirection == RIGHT)
		{
			velocityX = WALK_SPEED;
			facing = FlxObject.RIGHT;
		}
		
		velocity.set(velocityX, -JUMP_SPEED);
	}
	/**
	 * Sets up the walking state for the player.
	 *
	 * Specifically, this sets the player's velocity and their facing direction
	 * based on their motion direction. Also sets the drag force acting on them
	 * to zero.
	 */
	private function m_setupWalkingState():Void
	{
		var velocityX:Float;
		
		switch(m_motionDirection)
		{
			case LEFT:
				velocityX = -WALK_SPEED;
				facing = FlxObject.LEFT;
				animation.play("look_left");
			case RIGHT:
				velocityX = WALK_SPEED;
				facing = FlxObject.RIGHT;
				animation.play("look_right");
			default:
				velocityX = 0;
		}
		
		velocity.set(velocityX, 0);
		drag.set(0, drag.y);
	}
	/**
	 * Helps update the player in their walking state.
	 *
	 * This performs two important actions. First, it makes sure the direction
	 * the player is walking is correct. Second, it stops the player if they
	 * collide with anything on the left or the right.
	 *
	 * @param	direction	The direction that the player will be walking in.
	 */
	private function m_updateWalkingHelper():Void
	{
		if ((m_motionDirection == LEFT) != (velocity.x < 0))
		{
			m_setupWalkingState();
		}
		
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
			m_setState(IDLE);
		}
		else if (isTouching(FlxObject.UP))
		{
			velocity.set(velocity.x, 0);
		}
	}
	/**
	 * Helps update the player in their idle state.
	 *
	 * Currently does nothing, but it's being kept in case it is needed.
	 */
	private function m_updateIdleHelper():Void
	{
		
	}
}
