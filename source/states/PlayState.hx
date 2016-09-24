package states;

import entities.Player;
import entities.Coin;
import flixel.util.FlxPath;

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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _map:FlxOgmoLoader;
	private var _level:FlxTilemap;
	private var _collisionTiles:FlxTilemap;
	private var _player:Player;	
	private var _coinGroup:FlxTypedGroup<Coin>;
	private var _playerMovement:Bool = false;
	private var _collideLevel:FlxTilemap;
	inline static private var TILE_HEIGHT = 16;
	inline static private var TILE_WIDTH = 16;

	override public function create():Void {
		
		super.create();
		
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		
		/*
		level = map.loadTilemap(AssetPaths.tiles__png, TILE_WIDTH, TILE_HEIGHT, "walls");
		level.setTileProperties(1, FlxObject.NONE);
		level.setTileProperties(2, FlxObject.ANY);
		*/
		
		_collideLevel = new FlxTilemap();
		_collideLevel.loadMapFromCSV("assets/data/testmap.txt", AssetPaths.tiles__png, TILE_WIDTH, TILE_HEIGHT);
		_collideLevel.setTileProperties(1, FlxObject.NONE);
		_collideLevel.setTileProperties(2, FlxObject.ANY);
		
		_player = new Player(0, 0, _level);
		_player.path = new FlxPath();
		_coinGroup = new FlxTypedGroup<Coin>();
		
		_map.loadEntities(placeEntities, "entities");
		
		//add(level);
		add(_collideLevel);
		//add(coinGroup);
		add(_player);		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed) 
			movePlayer(FlxPoint.get(FlxG.mouse.screenX, FlxG.mouse.screenY));
		
		if (_playerMovement == true && _player.path.finished)
			stopMovement();
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void {
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
	
	private function movePlayer(goal:FlxPoint):Void {
		
		var goalMidpoint:FlxPoint = coordinatePointToTileMidpoint(goal);
		
		var pathPoints:Array<FlxPoint> = _collideLevel.findPath(_player.getMidpoint(), goalMidpoint);
			
		if (pathPoints != null) 
		{
			_player.path.start(pathPoints);
			_playerMovement = true;
		}		
	}
	
	private function stopMovement():Void {
		_playerMovement = false;
		_player.path.cancel();
		_player.velocity.x = _player.velocity.y = 0;
	}
	
	
	//	Uses x and y to calculate the tile row and column as a FlxPoint.
	private function coordinateXYToTile(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH), Std.int(Y / TILE_HEIGHT))); }
	
	//	Uses a FlxPoint to calculate the tile row and column as a FlxPoint.
	private function coordinatePointToTile(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH), Std.int(c.y / TILE_HEIGHT))); }
	
	//	Uses x and y to calculate the tile zero position as a FlxPoint.
	private function coordinateXYToTilePoint(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH) * TILE_WIDTH, Std.int(Y / TILE_HEIGHT) * TILE_HEIGHT)); }
	
	//	Uses a FlxPoint to calculate the tile zero position as a FlxPoint.
	private function coordinatePointToTilePoint(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH) * TILE_WIDTH, Std.int(c.y / TILE_HEIGHT) * TILE_HEIGHT));	}
	
	//	Uses x and y to calculate the tile midpoint as a FlxPoint.
	private function coordinateXYToTileMidpoint(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH) * TILE_WIDTH + TILE_WIDTH / 2, Std.int(Y / TILE_HEIGHT) * TILE_HEIGHT + TILE_HEIGHT / 2));	}
	
	//	Uses a FlxPoint to calculate the tile midpoint as a FlxPoint.
	private function coordinatePointToTileMidpoint(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH) * TILE_WIDTH + TILE_WIDTH / 2, Std.int(c.y / TILE_HEIGHT) * TILE_HEIGHT + TILE_HEIGHT / 2));	 }
	
	
}