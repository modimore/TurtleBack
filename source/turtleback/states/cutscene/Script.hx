package turtleback.states.cutscene;

/**
 * A list of lines corresponding to one speaker.
 */
typedef ScriptEntry = {
	speaker:String,
	lines:Array<String>
}
/**
 * A cutscene's script, composed of a sequence of groups of lines.
 */
typedef Script = Array<ScriptEntry>;
