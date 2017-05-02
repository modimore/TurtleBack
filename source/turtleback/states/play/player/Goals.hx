package turtleback.states.play.player;

using Lambda;

/**
 * Keeps track of the players objectives.
 */
class Goals
{
	private var m_itemQuotas:Map<String, Int>;
	private var m_goalsMet:Map<String, Bool>;
	
	public var met(get, null):Bool;
	
	/**
	 * Creates a new empty goals object.
	 */
	public function new()
	{
		m_itemQuotas = new Map<String, Int>();
		m_goalsMet = new Map<String, Bool>();
	}
	/**
	 * Adds a new item quota for the player to meet.
	 *
	 * @param	itemType	The type of item to add a quota for.
	 * @param	quota	The number of this type of item needed.
	 */
	public function addGoal(itemType:String, quota:Int):Void
	{
		m_itemQuotas.set(itemType, quota);
		m_goalsMet.set(itemType, false);
	}
	/**
	 * Checks whether or not a certain goal should be marked as complete.
	 * @param	itemType	The type of item to check.
	 * @param	count	The amount of that type of item collected so far.
	 */
	public function checkGoal(itemType:String, count:Int):Void
	{
		if (!m_itemQuotas.exists(itemType))
		{
			return;
		}
		
		if (count >= m_itemQuotas.get(itemType))
		{
			m_goalsMet.set(itemType, true);
		}
	}
	/**
	 * Checks and reports if all registered goals have been met.
	 *
	 * This is currently done by checking whether there is any goal that
	 * has not been met.
	 *
	 * @return	A boolean indicating whether all goals have been met.
	 */
	private function get_met():Bool
	{
		return !m_goalsMet.has(false);
	}
}
