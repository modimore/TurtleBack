package ext.flixel;

import flixel.FlxObject;

/**
 * A class that provides extensions for FlxObjects.
 *
 * Mostly these have to do with positioning FlxObjects relative to each other.
 */
class FlxObjectExt
{
	/**
	 * Aligns the left side of one FlxObject to the left side of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignLeft(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.x = objFixed.x;
	}
	/**
	 * Aligns the right side of one FlxObject to the right side of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignRight(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.x = objFixed.x + objFixed.width - objMobile.width;
	}
	/**
	 * Matches the horizontal midpoint of a FlxObject with that of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignCenterX(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.x = objFixed.x + (objFixed.width / 2) - (objMobile.width / 2);
	}
	/**
	 * Aligns the top of one FlxObject to the top of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignTop(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.y = objFixed.y;
	}
	/**
	 * Align the bottom of one FlxObject to the bottom of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignBottom(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.y = objFixed.y + objFixed.height - objMobile.height;
	}
	/**
	 * Matches the vertical midpoint of a FlxObject with that of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function alignCenterY(objMobile:FlxObject, objFixed:FlxObject):Void
	{
		objMobile.y = objFixed.y + (objFixed.height / 2) - (objMobile.height / 2);
	}
	/**
	 * Offsets the left of one sprite from the left of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function offsetFromLeft(objMobile:FlxObject, objFixed:FlxObject, offsetX:Float):Void
	{
		objMobile.x = objFixed.x + offsetX;
	}
	/**
	 * Offsets the right of one sprite from the right of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function offsetFromRight(objMobile:FlxObject, objFixed:FlxObject, offsetX:Float):Void
	{
		objMobile.x = objFixed.x + objFixed.width - objMobile.width + offsetX;
	}
	/**
	 * Offsets the top of one sprite from the top of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function offsetFromTop(objMobile:FlxObject, objFixed:FlxObject, offsetY:Float):Void
	{
		objMobile.y = objFixed.y + offsetY;
	}
	/**
	 * Offsets the bottom of one sprite from the bottom of another.
	 * @param	objMobile	The FlxObject that will be moved.
	 * @param	objFixed	The FlxObject serving as a position reference.
	 */
	static public function offsetFromBottom(objMobile:FlxObject, objFixed:FlxObject, offsetY:Float):Void
	{
		objMobile.y = objFixed.y + objFixed.height - objMobile.height + offsetY;
	}
}
