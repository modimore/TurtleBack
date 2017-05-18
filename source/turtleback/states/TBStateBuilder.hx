package turtleback.states;

import turtleback.states.cutscene.CutsceneState;
import turtleback.states.play.PlayState;

/**
 * Provides a way to request an instance of a state for this game.
 */
class TBStateBuilder
{
	/** A mapping to the known types of game states. */
	public static var states:Map<String, Class<TBBaseState>> = [
		"cutscene" => CutsceneState,
		"gameplay" => PlayState
	];
	
	/**
	 * Returns an instance of a state for this game.
	 *
	 * The instance will either be of the desired type, or will be an
	 * instance of TBBaseState if the requested type of state was not found.
	 *
	 * @param	typeID	The type of state to create.
	 * @param	stateID	The id of the state to create.
	 * @return	A valid state for this game.
	 */
	public static function buildState(typeID:String, stateID:String):TBBaseState
	{
		var c = states.get(typeID);
		
		if (c == null)
		{
			return new TBBaseState(stateID);
		}
		
		return Type.createInstance(c, [stateID]);
	}
}
