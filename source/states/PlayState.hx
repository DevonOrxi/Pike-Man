package states;

import entities.Player;
import entities.PlayerTest;
import entities.Coin;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.util.FlxPath;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _player:Player;
	private var _coinGroup:FlxTypedGroup<Coin>;
	private var _playerMovement:Bool = false;
	private var _collideLevel:FlxTilemap;

	override public function create():Void
	{

		super.create();
		
		FlxG.debugger.toggleKeys.push(FlxKey.V);
		FlxG.mouse.visible = false;

		var map:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.level1__oel);

		Reg.collideLevel = new FlxTilemap();
		Reg.collideLevel.loadMapFromCSV("assets/data/testmap.txt", AssetPaths.tiles3__png, Reg.TILE_WIDTH, Reg.TILE_HEIGHT);
		Reg.collideLevel.setTileProperties(1, FlxObject.NONE);
		Reg.collideLevel.setTileProperties(2, FlxObject.ANY);

		_player = new Player();
		_player.path = new FlxPath();
		_coinGroup = new FlxTypedGroup<Coin>();

		map.loadEntities(placeEntities, "entities");
		
		FlxG.camera.follow(_player);
		FlxG.camera.setScrollBounds(0, map.width, 0, map.height);
		
		add(Reg.collideLevel);
		//add(coinGroup);
		add(_player);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player, Reg.collideLevel);
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
		
		if (FlxG.mouse.justPressed)
			trace(FlxPoint.get(FlxG.mouse.screenX, FlxG.mouse.screenY));
			/*	movePlayer(FlxPoint.get(FlxG.mouse.screenX, FlxG.mouse.screenY));

		if (_playerMovement == true && _player.path.finished)
			stopMovement();
		*/
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_coinGroup.add(new Coin(x, y));
		}
	}
}