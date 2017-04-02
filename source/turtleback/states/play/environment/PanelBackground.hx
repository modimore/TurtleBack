package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

/**
 * Position and image data for a background panel.
 */
typedef PanelData = {
	x:Int,
	y:Int,
	image:String
};
/**
 * A background consistent of independent image panels.
 */
class PanelBackground extends FlxSpriteGroup
{
	/**
	 * Constructs a new background from an array of panel specifications.
	 * @param	panels	The positions and images for the panels.
	 */
	public function new(panels:Array<PanelData>)
	{
		super();
		
		for (panel in panels)
		{
			var sprite:FlxSprite = new FlxSprite();
			sprite.loadGraphic(panel.image);
			sprite.setPosition(panel.x, panel.y);
			sprite.scrollFactor.set(1, 1);
			add(sprite);
		}
	}
	/**
	 * Makes sure only the necessary panels are live in the scene.
	 *
	 * Any live offscreen panels are killed, and any dead onscreen panels revived.
	 *
	 * @param	dt	The time that has passed since the last update.
	 */
	override public function update(dt:Float)
	{
		forEachAlive(killSpriteIfOffScreen);
		forEachDead(reviveSpriteIfOnScreen);
		
		super.update(dt);
	}
	/**
	 * Kills a sprite if it is not visible currently.
	 * @param	s	The sprite to potentially kill.
	 */
	static private function killSpriteIfOffScreen(s:FlxSprite):Void
	{
		if (!s.isOnScreen())
		{
			s.kill();
		}
	}
	/**
	 * Revive a sprite if it is onscreen.
	 * @param	s	The sprite to potentially revive.
	 */
	static private function reviveSpriteIfOnScreen(s:FlxSprite):Void
	{
		if (s.isOnScreen())
		{
			s.revive();
		}
	}
}
