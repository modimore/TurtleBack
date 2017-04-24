package turtleback.states.play.player;

using Lambda;

class Goals
{
	private var m_itemQuotas:Map<String, Int>;
	private var m_goalsMet:Map<String, Bool>;
	
	public var met(get, null):Bool;
	
	public function new()
	{
		m_itemQuotas = new Map<String, Int>();
		m_goalsMet = new Map<String, Bool>();
	}
	
	public function addGoal(itemType:String, quota:Int)
	{
		m_itemQuotas.set(itemType, quota);
		m_goalsMet.set(itemType, false);
	}
	
	public function checkGoal(itemType:String, count:Int)
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
	
	private function get_met()
	{
		return !m_goalsMet.has(false);
	}
}
