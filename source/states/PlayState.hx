package states;

import entities.Player;
import entities.Coin;
import flixel.util.FlxPath;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import openfl.Assets;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var map:FlxOgmoLoader;
	private var level:FlxTilemap;
	private var collisionTiles:FlxTilemap;
	private var player:Player;	
	private var coinGroup:FlxTypedGroup<Coin>;
	private var playerMovement:Bool = false;
	private var path:FlxPath;
	private var collideLevel:FlxTilemap;
	inline static private var TILE_HEIGHT = 16;
	inline static private var TILE_WIDTH = 16;

	override public function create():Void {
		
		super.create();
		
		map = new FlxOgmoLoader(AssetPaths.level1__oel);
		
		/*
		level = map.loadTilemap(AssetPaths.tiles__png, TILE_WIDTH, TILE_HEIGHT, "walls");
		level.setTileProperties(1, FlxObject.NONE);
		level.setTileProperties(2, FlxObject.ANY);
		*/
		
		collideLevel = new FlxTilemap();
		collideLevel.loadMap(Assets.getText("assets/data/testmap.txt"), AssetPaths.tiles__png, TILE_WIDTH, TILE_HEIGHT);
		collideLevel.setTileProperties(1, FlxObject.NONE);
		collideLevel.setTileProperties(2, FlxObject.ANY);
		
		player = new Player(0, 0, level);
		coinGroup = new FlxTypedGroup<Coin>();
		
		path = new FlxPath();
		
		map.loadEntities(placeEntities, "entities");
		
		//add(level);
		add(collideLevel);
		//add(coinGroup);
		add(player);		
	}

	override public function update():Void {
		
		if (FlxG.mouse.justPressed) 
			movePlayer(FlxPoint.get(FlxG.mouse.screenX, FlxG.mouse.screenY));
		
		if (playerMovement == true && path.finished)
			stopMovement();
		
		super.update();		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player")
		{
			player.x = x;
			player.y = y;
		}
		else if (entityName == "coin")
		{
			coinGroup.add(new Coin(x, y));
		}
	}
	
	private function movePlayer(goal:FlxPoint):Void {
		
		var goalMidpoint:FlxPoint = FlxPoint.get(Std.int(goal.x / TILE_WIDTH) * TILE_WIDTH + TILE_WIDTH / 2, Std.int(goal.y / TILE_HEIGHT) * TILE_HEIGHT + TILE_HEIGHT / 2);
		
		var pathPoints:Array<FlxPoint> = collideLevel.findPath(player.getMidpoint(), goalMidpoint);
			
		if (pathPoints != null) 
		{
			path.start(player, pathPoints);
			playerMovement = true;
		}		
	}
	
	private function stopMovement():Void {
		playerMovement = false;
		path.cancel();
		player.velocity.x = player.velocity.y = 0;
	}
}