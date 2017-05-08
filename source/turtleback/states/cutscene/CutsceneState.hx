package turtleback.states.cutscene;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

import turtleback.states.cutscene.ui.DialogUI;

import turtleback.states.play.PlayState;

import turtleback.states.shared.TBEntity;

using ext.flixel.FlxObjectExt;

/**
 * The cutscene state for this game.
 */
class CutsceneState extends FlxState
{
	private static var LINES_INTRO:Script = [
		{
			speaker: "Wizard",
			lines: [
				"",
				"I'm a wizard.",
				"Please find some mushrooms for my pig. I need three purple mushrooms for their dinner."
			]
		},
		{
			speaker: "??????",
			lines: [
				"Okay.",
				""
			]
		}
	];
	private static var LINES_OUTRO:Script = [
		{
			speaker: "Wizard",
			lines: [
				"Thanks for getting me those mushrooms.",
				""
			]
		}
	];
	
	private var m_script:Script;
	private var m_currentLines:Array<String>;
	private var m_scriptEntryIndex:Int = 0;
	private var m_lineIndex:Int = 0;
	
	private var m_bg:FlxSprite;
	private var m_dialogUI:DialogUI;
	private var m_actors:Map<String, TBEntity>;
	
	private var m_isOutro:Bool;
	
	public function new(outro:Bool = false)
	{
		super();
		
		if (outro)
		{
			m_script = LINES_OUTRO;
		}
		else
		{
			m_script = LINES_INTRO;
		}
		
		m_isOutro = outro;
	}
	/**
	 * Creates the actors and the dialog UI element.
	 */
	override public function create():Void
	{
		m_actors = new Map<String, TBEntity>();
		m_bg = new FlxSprite("assets/images/bg-hut.png");
		add(m_bg);
		
		var player:TBEntity = new TBEntity("??????");
		player.offsetFromLeft(m_bg, 90);
		player.offsetFromBottom(m_bg, -72);
		m_actors.set("??????", player);
		
		var wizard:TBEntity = new TBEntity("wizard");
		wizard.offsetFromRight(m_bg, -60);
		wizard.offsetFromBottom(m_bg, -72);
		m_actors.set("wizard", wizard);
		
		var pig:TBEntity = new TBEntity("pig");
		pig.alignBottom(wizard);
		pig.offsetFromRight(wizard, -30);
		m_actors.set("pig", pig);
		
		add(player);
		add(wizard);
		add(pig);
		
		player.animation.play("look_right");
		wizard.animation.play("look_left");
		pig.animation.play("look_left");
		
		m_dialogUI = new DialogUI(0, 0, FlxG.width - 20, 60);
		m_dialogUI.alignCenterX(m_bg);
		m_dialogUI.offsetFromTop(m_bg, 10);
		add(m_dialogUI);
		
		m_scriptEntryIndex = 0;
		m_lineIndex = 0;
		m_currentLines = m_script[m_scriptEntryIndex].lines;
		
		m_dialogUI.setSpeaker(m_script[m_scriptEntryIndex].speaker, m_currentLines[m_lineIndex]);
	}
	/**
	 * Allows FlxObjects in this scene to update.
	 *
	 * Notably, this method handles the logistics of line advancement.
	 *
	 * @param	dt	The time that has passed since the last update.
	 */
	override public function update(dt:Float):Void
	{
		super.update(dt);
		
		if (FlxG.keys.anyJustPressed([Z]))
		{
			++m_lineIndex;
			
			if (m_lineIndex >= m_currentLines.length)
			{
				++m_scriptEntryIndex;
				
				if (m_scriptEntryIndex >= m_script.length)
				{
					if (m_isOutro)
					{
						FlxG.switchState(new CutsceneState(false));
					}
					else
					{
						FlxG.switchState(new PlayState());
					}
				}
				else
				{
					m_currentLines = m_script[m_scriptEntryIndex].lines;
					m_lineIndex = 0;
					m_dialogUI.setSpeaker(m_script[m_scriptEntryIndex].speaker, m_currentLines[m_lineIndex]);
				}
				
				return;
			}
			
			m_dialogUI.setLine(m_currentLines[m_lineIndex]);
		}
	}
}
