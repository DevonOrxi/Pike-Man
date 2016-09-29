package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.util.FlxPath;

/**
 * ...
 * @author Acid
 */
class Player extends FlxSprite
{
	private var tilePosition:FlxPoint;
	private var moving:Bool;

	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X,Y);

		loadGraphic(AssetPaths.player__png, true, 16, 16);
		animation.add("walkLeft", [ 0, 1 ], 5, true);
		animation.add("walkDown", [ 2, 3 ], 5, true);
		animation.add("walkUp", [ 4, 5 ], 5, true);
		animation.add("walkRight", [ 6, 7 ], 5, true);
		animation.play("walkDown");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		checkInput();

		tilePosition = Reg.coordinateXYToCR(x, y);

		switch (Reg.keyCodesCur)
		{
			case 2:
				
				if (Reg.keyCodesCur != Reg.keyCodesPre)
					lookForPathUp();
					
				animation.play("walkUp");
				
				
			case 3:
				velocity.x = Reg.playerSpeed;
				animation.play("walkRight");
			case 5:
				velocity.y = Reg.playerSpeed;
				animation.play("walkDown");
			case 7:
				velocity.x = -Reg.playerSpeed;
				animation.play("walkLeft");
			default:
				animation.stop();
				stopMovement();			
		}

		Reg.keyCodesPre = Reg.keyCodesCur;
	}

	private function moveAlongPath(goal:FlxPoint):Void {

		var goalMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(goal);

		var pathPoints:Array<FlxPoint> = Reg.collideLevel.findPath(getMidpoint(), goalMidpoint);

		if (pathPoints != null)
		{
			path.start(pathPoints);
			moving = true;
		}
	}

	private function stopMovement():Void {
		moving = false;
		path.cancel();
		velocity.x = velocity.y = 0;
	}

	private function checkInput():Void {
		
		Reg.keyCodesCur = 1;
		Reg.keyCodesCur *= ((FlxG.keys.pressed.UP || FlxG.keys.pressed.W) ? Reg.CODEVALUE_UP : 1)
			* ((FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) ? Reg.CODEVALUE_RIGHT : 1)
			* ((FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) ? Reg.CODEVALUE_DOWN : 1)
			* ((FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) ? Reg.CODEVALUE_LEFT : 1)
		;
	}

	private function lookForPathUp():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (x + origin.x == currentTileMidpoint.x)
		{
			endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_UP);
			/*
			var upTile:FlxPoint;
			var i:Int = 1;
			var upTileType:Int;
			
			do
			{
				upTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT * i);
				upTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(upTile));
				i++;
			}
			while (upTileType != 2 && upTileType != null);
			
			upTile.y += Reg.TILE_HEIGHT;
			*/
			
			moveAlongPath(endTile);
			trace("EQUALS || " + endTile);
		}
		else if (x + origin.x > currentTileMidpoint.x)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
			var upTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (upTileType == 2)
				endTile = findPath(x + width / 2 + Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_UP);
			else
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_UP);
			
			/*
			var upTile:FlxPoint;
			var i:Int = 1;
			var upTileType:Int;
			
			upTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
			upTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(upTile));
			
			if (upTileType == 2)
			{			
				do
				{
					upTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT * i);
					upTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(upTile));
					i++;
				}
				while (upTileType != 2 && upTileType != null);
			}
			else
			{
				do
				{
					upTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT * i);
					upTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(upTile));
					i++;
				}
				while (upTileType != 2 && upTileType != null);
			}
			
			upTile.y += Reg.TILE_HEIGHT;
			*/
			
			moveAlongPath(endTile);
			
			trace("MAJOR || " + endTile);
		}
		else
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
			var upTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (upTileType == 2)
				endTile = findPath(x + width / 2 - Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_UP);
			else
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_UP);
			/*
			var upTile:FlxPoint;
			var i:Int = 1;
			var upTileType:Int;
			
			do
			{
				upTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT * i);
				upTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(upTile));
				i++;
			}
			while (upTileType != 2 && upTileType != null);
			
			upTile.y += Reg.TILE_HEIGHT;
			*/
			
			moveAlongPath(endTile);			
			trace("MINOR || " + endTile);
		}
		
	}
	
	private function findPath(startingX:Float, startingY:Float, direction:Int):FlxPoint
	{
		var nextTile:FlxPoint = null;
		var nextTileType:Int;
		var i:Int = 1;
		
		switch(direction)
		{
			case Reg.CODEVALUE_UP:
				do
				{
					nextTile = Reg.coordinateXYToTileMidpoint(startingX, startingY - Reg.TILE_HEIGHT * i);
					nextTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(nextTile));
					i++;
				}
				while (nextTileType != 2 && nextTileType != null);		
				
				nextTile.y += Reg.TILE_HEIGHT;
		}
		
		//FlxG.state.add(new FlxSprite(nextTile.x, nextTile.y, AssetPaths.coin__png));
		
		return nextTile;
	}

}