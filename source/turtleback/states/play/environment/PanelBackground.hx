package turtleback.states.play.environment;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.group.FlxSpriteGroup;

typedef PanelData = {
	x:Int,
	y:Int,
	image:String
};

class PanelBackground extends FlxSpriteGroup
{
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
	
	override public function update(dt:Float)
	{
		forEachAlive(killSpriteIfOffScreen);
		forEachDead(reviveSpriteIfOnScreen);
		
		super.update(dt);
	}
	
	static private function killSpriteIfOffScreen(s:FlxSprite):Void
	{
		if (!s.isOnScreen())
		{
			s.kill();
		}
	}
	
	static private function reviveSpriteIfOnScreen(s:FlxSprite):Void
	{
		if (s.isOnScreen())
		{
			s.revive();
		}
	}
}
