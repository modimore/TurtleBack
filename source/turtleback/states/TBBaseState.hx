package turtleback.states;

import flixel.FlxState;
import flixel.util.FlxSignal;

/**
 * Superclass of all states for this game.
 */
class TBBaseState extends FlxState
{
	/** The identifier for the state. */
	public var stateID(default, null):String;
	/** A signal that is fired when the state ends. */
	public var stateEndSignal(default, null):FlxSignal;
	
	/**
	 * Constructs an instance of a state for this game.
	 * @param	a_stateID	The ID of the state to be constructed.
	 */
	public function new(a_stateID:String)
	{
		super();
		
		stateID = a_stateID;
		stateEndSignal = new FlxSignal();
	}
	/**
	 * Internal method that should be called to end the state.
	 *
	 * Sends the proper signal out to all listeners, notably the state
	 * machine that will load the next state.
	 */
	private function m_endState():Void
	{
		stateEndSignal.dispatch();
	}
}
