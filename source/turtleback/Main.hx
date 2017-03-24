package turtleback;

import openfl.display.Sprite;
import flixel.FlxGame;

import turtleback.states.play.PlayState;

/**
 * Entry point for our game.
 *
 * This is where OpenFL will start our game loop.
 */
class Main extends Sprite
{
	public function new()
	{
		super();
		
		this.addChild(new FlxGame(0, 0, PlayState));
	}
}
