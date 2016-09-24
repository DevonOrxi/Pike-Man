package entities;
import flixel.FlxSprite;

/**
 * ...
 * @author Acid
 */
class Coin extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?graphic:Dynamic)
	{
		super(X,Y,graphic);
		
		loadGraphic(AssetPaths.coin__png);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
}