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
				{					
					lookForPathUp();
					animation.play("walkUp");
				}
				
				
			case 3:				
				if (Reg.keyCodesCur != Reg.keyCodesPre)
				{
					lookForPathRight();				
					animation.play("walkRight");
				}
				
			case 5:				
				if (Reg.keyCodesCur != Reg.keyCodesPre)
				{
					lookForPathDown();
					animation.play("walkDown");
				}	
				
			case 7:				
				if (Reg.keyCodesCur != Reg.keyCodesPre)
				{
					lookForPathLeft();
					animation.play("walkLeft");
				}
				
			default:
				animation.stop();
				stopMovement();			
		}
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
		Reg.keyCodesPre = Reg.keyCodesCur;
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
			
			moveAlongPath(endTile);
			//	trace("EQUALS || " + endTile);
		}
		else if (x + origin.x > currentTileMidpoint.x)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
			var upTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (upTileType == 2)
			{				
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				trace(diagTileType);
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2 + Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_UP);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_UP);		
				moveAlongPath(endTile);
			}
			
			//	trace("MAJOR || " + endTile);
		}
		else
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
			var upTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (upTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT);				
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2 - Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_UP);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_UP);		
				moveAlongPath(endTile);
			}
			
			//	trace("MINOR || " + endTile);
		}
		
	}
	private function lookForPathRight():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (y + origin.y == currentTileMidpoint.y)
		{
			endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_RIGHT);
			
			moveAlongPath(endTile);
			//	trace("EQUALS || " + endTile);
		}
		else if (y + origin.y > currentTileMidpoint.y)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2);
			var rightTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (rightTileType == 2)
			{				
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 + Reg.TILE_HEIGHT);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				trace(diagTileType);
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT, Reg.CODEVALUE_RIGHT);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_RIGHT);		
				moveAlongPath(endTile);
			}
			
			//	trace("MAJOR || " + endTile);
		}
		else
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2);
			var rightTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (rightTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT);				
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT, Reg.CODEVALUE_RIGHT);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_RIGHT);		
				moveAlongPath(endTile);
			}
			
			trace("MINOR || " + endTile);
		}
		
	}
	private function lookForPathDown():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (x + origin.x == currentTileMidpoint.x)
		{
			endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_DOWN);			
			moveAlongPath(endTile);
			//	trace("EQUALS || " + endTile);
		}
		else if (x + origin.x > currentTileMidpoint.x)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT);
			var downTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (downTileType == 2)
			{				
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 + Reg.TILE_HEIGHT);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2 + Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_DOWN);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_DOWN);		
				moveAlongPath(endTile);
			}
			
			//	trace("MAJOR || " + endTile);
		}
		else
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT);
			var downTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (downTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2 + Reg.TILE_HEIGHT);				
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2 - Reg.TILE_WIDTH, y + height / 2, Reg.CODEVALUE_DOWN);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_DOWN);		
				moveAlongPath(endTile);
			}
			
			//	trace("MINOR || " + endTile);
		}
		
	}
	private function lookForPathLeft():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (y + origin.y == currentTileMidpoint.y)
		{
			endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_LEFT);
			
			moveAlongPath(endTile);
			//	trace("EQUALS || " + endTile);
		}
		else if (y + origin.y > currentTileMidpoint.y)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2);
			var leftTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (leftTileType == 2)
			{				
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2 + Reg.TILE_HEIGHT);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				trace(diagTileType);
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT, Reg.CODEVALUE_LEFT);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_LEFT);		
				moveAlongPath(endTile);
			}
			
			//	trace("MAJOR || " + endTile);
		}
		else
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2);
			var leftTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (leftTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 - Reg.TILE_WIDTH, y + height / 2 - Reg.TILE_HEIGHT);				
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT, Reg.CODEVALUE_LEFT);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2, Reg.CODEVALUE_LEFT);		
				moveAlongPath(endTile);
			}
			
			//	trace("MINOR || " + endTile);
		}
		
	}
	private function findPath(startingX:Float, startingY:Float, direction:Int):FlxPoint {
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
				while (nextTileType != 2);
				
				nextTile.y += Reg.TILE_HEIGHT;
			
			case Reg.CODEVALUE_RIGHT:
				do
				{
					nextTile = Reg.coordinateXYToTileMidpoint(startingX + Reg.TILE_WIDTH * i, startingY);
					nextTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(nextTile));
					i++;
				}
				while (nextTileType != 2);		
				
				nextTile.x -= Reg.TILE_WIDTH;
			
			case Reg.CODEVALUE_DOWN:
				do
				{
					nextTile = Reg.coordinateXYToTileMidpoint(startingX, startingY + Reg.TILE_HEIGHT * i);
					nextTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(nextTile));
					i++;
				}
				while (nextTileType != 2);		
				
				nextTile.y -= Reg.TILE_HEIGHT;
				
			case Reg.CODEVALUE_LEFT:
				do
				{
					nextTile = Reg.coordinateXYToTileMidpoint(startingX - Reg.TILE_WIDTH * i, startingY);
					nextTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(nextTile));
					i++;
				}
				while (nextTileType != 2);		
				
				nextTile.x += Reg.TILE_WIDTH;
		}
		
		//FlxG.state.add(new FlxSprite(nextTile.x, nextTile.y, AssetPaths.coin__png));
		
		return nextTile;
	}

}