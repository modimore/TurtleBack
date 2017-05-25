package ext.haxe;

/**
 * A collection of interpolation functions.
 *
 * The static members of this class are meant to be used to
 * transform a value in the range [0, 1] to another value
 * in the range [0, 1], much like an easing function.
 *
 * Functions in this class do not necessarily monotonically
 * increase with their parameter t.
 */
class Interpolation
{
	/**
	 * This is a trivial interpolation that always returns `1.0`.
	 * @param	t	The input parameter.
	 * @return	The interpolated value, always 1.0 here.
	 */
	public static function constant(t:Float):Float
	{
		return 1.0;
	}
	/**
	 * A linear interpolation function.
	 * @param	t	The input parameter.
	 * @return	The value of the input parameter.
	 */
	public static function linear(t:Float):Float
	{
		return t;
	}
	/**
	 * An interpolation function for a parabolic curve.
	 *
	 * The parabola this function refers to has its vertex at t = 0.5.
	 * To this function, the vertex represents the maximum value of 1.0
	 * so that it will be the lowest point in screen space when used with
	 * a positive coefficient.
	 *
	 * @param	t	The input parameter.
	 * @return	The time on the parabola.
	 */
	public static function parabolic(t:Float):Float
	{
		t = 2.0 * (t - 0.5);
		return 1.0 - t * t;
	}
}
