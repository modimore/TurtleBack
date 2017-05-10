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
	 * Places the supplied object at ground level in the supplied segment.
	 * @param	o	The object to place on the ground.
	 * @param	g	The ground segment to use the height values for.
	 */
	public static function placeObjectAtGround(o:FlxObject, g:GroundObject):Void
	{
		var oCenterX = o.x + (o.width / 2);
		o.y = g.getGroundHeightAt(oCenterX) - o.height;
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
