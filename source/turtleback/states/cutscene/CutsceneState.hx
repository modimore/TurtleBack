package turtleback.states.cutscene;

import haxe.Json;
import openfl.Assets;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

import turtleback.states.cutscene.ui.DialogUI;

import turtleback.states.play.PlayState;

import turtleback.states.shared.TBEntity;

using ext.flixel.FlxObjectExt;

typedef CutsceneData = {
	var actors:Array<{ id:String, x:Int, y:Int, initial_anim:String }>;
	var script:Script;
}

/**
 * The cutscene state for this game.
 */
class CutsceneState extends FlxState
{
	private var m_dataPath:String;
	
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
			m_dataPath = "assets/data/cutscenes/dev_outro.json";
		}
		else
		{
			m_dataPath = "assets/data/cutscenes/dev_intro.json";
		}
		
		m_isOutro = outro;
	}
	/**
	 * Creates the actors and the dialog UI element.
	 */
	override public function create():Void
	{
		m_actors = new Map<String, TBEntity>();
		m_bg = new FlxSprite("assets/images/backgrounds/hut.png");
		add(m_bg);
		
		if (Assets.exists(m_dataPath, AssetType.TEXT))
		{
			var data:CutsceneData = Json.parse(Assets.getText(m_dataPath));
			
			for (actor in data.actors)
			{
				var actorEntity = new TBEntity(actor.id, actor.x, actor.y);
				actorEntity.animation.play(actor.initial_anim);
				m_actors.set(actor.id, actorEntity);
				add(actorEntity);
			}
			
			m_script = data.script;
		}
		
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
