package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Acid
 */
class Player extends FlxSprite
{
	private var _level:FlxTilemap;
	
	public function new(X:Int = 0, Y:Int = 0, ?level:FlxTilemap) 
	{
		super(X,Y);
		
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		animation.add("walkLeft", [ 0, 1 ], 5, true);
		animation.add("walkDown", [ 2, 3 ], 5, true);
		animation.add("walkUp", [ 4, 5 ], 5, true);
		animation.add("walkRight", [ 6, 7 ], 5, true);
		
		animation.play("walkDown");
		
		_level = level;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		/*	
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
		{
			velocity.x = -Reg.playerSpeed;
			animation.play("walkLeft");
		}
		else if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
		{
			velocity.x = Reg.playerSpeed;
			animation.play("walkRight");
		}
		else
			velocity.x = 0;
			
		
		if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W)
		{
			velocity.y = -Reg.playerSpeed;
			animation.play("walkUp");
		}
		else if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S)
		{
			velocity.y = Reg.playerSpeed;
			animation.play("walkDown");
		}
		else
			velocity.y = 0;		
		*/
	}
	
}