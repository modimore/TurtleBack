package turtleback.states.play;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * A group of FlxObjects meant to follow around another FlxObject.
 */
class FlxObjectFollower extends FlxGroup
{
	public var anchor(default, null):FlxObject;
	
	private var m_target:FlxObject;
	
	private var m_maxDistanceX:Float;
	private var m_maxDistanceY:Float;
	
	/**
	 * Create the following group with an anchor object.
	 * @param	{FlxObject}	target	The FlxObject to follow
	 * @param	{Float} distanceX	Maximum distance on x-axis from the target
	 * @param	{Float}	distanceY Maximum distance on y-axis from the target
	 * @param	{Float = null}	x	Initial X position for the group.
	 * @param	{Float = null}	y	Initial Y position for the group.
	 */
	public function new(target:FlxObject,
		distanceX:Float, distanceY:Float,
		?x:Float = null, ?y:Float = null)
	{
		super();
		
		m_target = target;
		
		m_maxDistanceX = distanceX;
		m_maxDistanceY = distanceY;
		
		if (x == null)
		{
			x = m_target.x;
		}
		
		if (y == null)
		{
			y = m_target.y;
		}
		
		anchor = new FlxObject(x, y, 0, 0);
		add(anchor);
	}
	
	/**
	 * Follows the target every update step.
	 * @param	{Float}	dt	The time in seconds since the last update
	 */
	override public function update(dt:Float):Void
	{
		followTarget(dt);
		super.update(dt);
	}
	
	private function followTarget(dt:Float) {
		var x:Float = anchor.x;
		var y:Float = anchor.y;
		var nextX:Float = anchor.x;
		var nextY:Float = anchor.y;
		
		if (x > m_target.x + m_maxDistanceX)
		{
			nextX = m_target.x + m_maxDistanceX;
		}
		else if (x < m_target.x + m_target.width - m_maxDistanceX)
		{
			nextX = m_target.x + m_target.width - m_maxDistanceX;
		}
		
		if (y > m_target.y + m_maxDistanceY)
		{
			nextY = m_target.y + m_maxDistanceY;
		}
		else if (y < m_target.y + m_target.height - m_maxDistanceY)
		{
			nextY = m_target.y + m_target.height - m_maxDistanceY;
		}
		
		anchor.setPosition(nextX, nextY);
	}
}
