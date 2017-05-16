package turtleback;

import haxe.Json;

import openfl.Assets;
import openfl.display.Sprite;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;

import turtleback.states.TBBaseState;
import turtleback.states.cutscene.CutsceneState;
import turtleback.states.play.PlayState;

typedef StateInfo = {
	var type:String;
	var id:String;
}

/**
 * Entry point for our game.
 *
 * This is where OpenFL will start our game loop.
 */
class Main extends Sprite
{
	private var m_stateData:Array<StateInfo>;
	private var m_stateIndex:Int;
	
	public function new()
	{
		super();
		
		this.addChild(new FlxGame(0, 0, null));
		
		m_stateIndex = -1;
		
		if (Assets.exists("assets/data/state_order.json", AssetType.TEXT))
		{
			m_stateData = Json.parse(Assets.getText("assets/data/state_order.json"));
		}
		else
		{
			m_stateData = [];
		}
		
		if (m_stateData.length > 0)
			advanceState();
	}
	
	public function advanceState():Void
	{
		m_stateIndex += 1;
		if (m_stateIndex == m_stateData.length)
			m_stateIndex = 0;
		
		var nextState:TBBaseState = switch(m_stateData[m_stateIndex].type)
		{
			case "cutscene":
				new CutsceneState(m_stateData[m_stateIndex].id);
			case "gameplay":
				new PlayState(m_stateData[m_stateIndex].id);
			case _:
				new TBBaseState("INVALID");
		}
		
		nextState.stateEndSignal.addOnce(advanceState);
		FlxG.switchState(nextState);
	}
}
