package turtleback.states.play.environment;

import flixel.FlxObject;

import ext.haxe.Interpolation;

/**
 * The data required to construct a ground segment.
 *
 * Includes information about an interpolation style and the heights
 * that the ground level should always be between.
 */
typedef GroundData = {
	var interpolationType:String;
	var height1:Float;
	var height2:Float;
}

/**
 * An extension of a FlxObject that represents a segment of ground.
 *
 * Each segment can find the correct ground height anywhere between its
 * two endpoints. The class is also used to set other objects to the correct
 * height and check where they are relative to the ground.
 */
class GroundObject extends FlxObject
{
	private static var GROUND_EPSILON = 1.0;
	private var m_groundBaseY:Float;
	private var m_groundDeltaY:Float;
	private var m_groundInterpolator:Float->Float;
	
	/**
	 * Handles collisions between a FlxObject and a ground tile.
	 *
	 * This handles the effects of a collision only if it should happen,
	 * otherwise it does nothing and returns false to signify that the
	 * collision has not taken place.
	 *
	 * @param	o	The possibly-colliding object.
	 * @param	g	The ground segment to check.
	 */
	public static function collideObjectWithGround(o:FlxObject, g:GroundObject):Bool
	{
		// These values are relevant for the rest of the function.
		var oBottomY = o.y + o.height;
		var oCenterX = o.x + (o.width / 2);
		var groundHeight = g.getGroundHeightAt(oCenterX);
		
		// A collision is not happening if any of the following are true:
		// - the object parameter is rising.
		// - the bottom of the object is already touching something
		// - The center of the object is not over this ground segment
		// - the bottom of the object is below this ground segment
		// - the bottom of the object is above the ground level
		var areNotColliding = false
			|| o.velocity.y < 0
			|| o.isTouching(FlxObject.DOWN)
			|| oCenterX < g.x || oCenterX > g.x + g.width
			|| oBottomY > g.y + g.height
			|| groundHeight > oBottomY;
		
		if (areNotColliding)
			return false;
		
		// Place the object at the correct ground level,
		// set its touching flag to true in the down direction,
		// and set its velocity to zero.
		o.y = groundHeight - o.height;
		o.touching |= FlxObject.DOWN;
		o.velocity.y = 0;
		return true;
	}
	
	/**
	 * Constructs a new ground object from ground data and object properties.
	 * @param	x	The x position of the collision area.
	 * @param	y	The y position of the collision area.
	 * @param	width	The width of the collision area.
	 * @param height	The height of the collision area.
	 * @param	data	The ground level data for the current segment.
	 */
	public function new(
		x:Float, y:Float, width:Float, height:Float, data:GroundData)
	{
		m_groundBaseY = data.height1;
		m_groundDeltaY = data.height2 - data.height1;
		m_groundInterpolator = switch(data.interpolationType)
		{
			case "constant":
				Interpolation.constant;
			case "linear":
				Interpolation.linear;
			default:
				Interpolation.constant;
		}
		
		super(x, y, width, height);
		
		immovable = true;
		moves = false;
	}
	
	/**
	 * Checks whether or this segment should correspond to an object.
	 *
	 * To avoid ambiguity, the correct ground level for an object is the ground
	 * level under its center. As such, the ground segment under the center of
	 * an object is the one 'directly under' that object.
	 *
	 * @param	o	The object to check against.
	 * @return	Whether that object is directly over this segment.
	 */
	public function isDirectlyUnder(o:FlxObject):Bool
	{
		var oCenterX = o.x + (o.width / 2);
		var oBottomY = o.y + o.height;
		
		return !(oCenterX < x || oCenterX > x + width || oBottomY > y + height);
	}
	/**
	 * Checks whether an object is above ground level.
	 *
	 * The check is performed relative to the ground level at the center of
	 * the object.
	 *
	 * @param	o	The object to check.
	 * @return	Whether the object is fully above ground.
	 */
	public function isAboveGround(o:FlxObject):Bool
	{
		var oCenterX = o.x + (o.width / 2);
		var oBottomY = o.y + o.height;
		
		return getGroundHeightAt(oCenterX) - oBottomY > GROUND_EPSILON;
	}
	/**
	 * Finds the ground height at a specific x position.
	 * @param	a_x	The relevant x position.
	 * @return	The ground level at the input x position.
	 */
	public function getGroundHeightAt(a_x:Float):Float
	{
		if (a_x < x)
		{
			return m_groundBaseY + m_groundDeltaY * m_groundInterpolator(0.0);
		}
		else if (a_x > x + width)
		{
			return m_groundBaseY + m_groundDeltaY * m_groundInterpolator(1.0);
		}
		else
		{
			var relativeX:Float = (a_x - x) / width;
			return m_groundBaseY + m_groundDeltaY * m_groundInterpolator(relativeX);
		}
	}
}
