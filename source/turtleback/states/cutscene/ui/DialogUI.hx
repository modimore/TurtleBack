package turtleback.states.cutscene.ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using ext.flixel.FlxObjectExt;

/**
 * A UI Element for dialog that identifies the speaker and displays text.
 */
class DialogUI extends FlxSpriteGroup
{
	private static var BG_COLOR = FlxColor.GRAY;
	private static var FONT_SIZE = 16;
	private var m_bg:FlxSprite;
	private var m_speakerIdentifier:FlxText;
	private var m_currentLine:FlxText;
	
	/**
	 * Constructs a new dialog UI element.
	 * @param	x	The reference x coordinate for the positioning of components.
	 * @param	y	The reference y coordinate for the positioning of components.
	 * @param	width	The width of the dialog background.
	 * @param	height The height of the dialog background.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float, height:Float)
	{
		super(x, y);
		moves = false;
		solid = false;
		
		m_bg = new FlxSprite();
		m_bg.makeGraphic(Std.int(width), Std.int(height), BG_COLOR);
		m_bg.moves = false;
		m_bg.solid = false;
		
		m_speakerIdentifier = new FlxText();
		m_speakerIdentifier.size = FONT_SIZE;
		m_speakerIdentifier.offsetFromLeft(this, 10);
		
		m_currentLine = new FlxText();
		m_currentLine.size = FONT_SIZE;
		m_currentLine.offsetFromLeft(m_speakerIdentifier, m_speakerIdentifier.width);
		
		add(m_bg);
		add(m_speakerIdentifier);
		add(m_currentLine);
	}
	/**
	 * Sets the current speaker, and optionally a starting line.
	 *
	 * If a line is not specified, the dialog box will disappear until
	 * a line is set.
	 *
	 * @param	speakerName	The name of the upcoming speaker.
	 * @param	text	The speaker's initial line, if any.
	 */
	public function setSpeaker(speakerName:String, line:String=""):Void
	{
		m_speakerIdentifier.text = speakerName;
		
		m_currentLine.offsetFromLeft(m_speakerIdentifier, m_speakerIdentifier.width + 10);
		m_currentLine.fieldWidth = width - (m_currentLine.x - x) - 10;
		setLine(line);
	}
	/**
	 * Sets the current line.
	 * @param	line The line to display.
	 */
	public function setLine(line:String):Void
	{
		m_currentLine.text = line;
		visible = line != "";
	}
}
