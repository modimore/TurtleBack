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
}
