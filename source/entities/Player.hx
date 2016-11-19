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
	private var dirVersor:FlxPoint;

	public function new(X:Int = 0, Y:Int = 0)
	{
		super(X,Y);

		loadGraphic(AssetPaths.pikeman__png, true, 16, 16);
		animation.add("walkDown", [ 4, 8, 12, 0 ], 8, true);
		animation.add("walkUp", [ 5, 9, 13, 1 ], 8, true);
		animation.add("walkLeft", [ 6, 10, 14, 2 ], 8, true);
		animation.add("walkRight", [ 7, 11, 15, 3 ], 8, true);
		animation.play("walkDown");
		
		dirVersor = new FlxPoint();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		checkInput();

		tilePosition = Reg.coordinateXYToCR(x, y);
	}

	private function moveAlongPath(goal:FlxPoint, ?forcedPoint:FlxPoint = null):Void {

		var goalMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(goal);

		var pathPoints:Array<FlxPoint> = Reg.collideLevel.findPath(getMidpoint(), goalMidpoint);
		if (forcedPoint != null)
			pathPoints.insert(1, forcedPoint);
		
		trace(pathPoints);

		if (pathPoints != null)
		{
			path.start(pathPoints);
			moving = true;
		}
	}
	private function stopMovement():Void {
		dirVersor.set(0, 0);
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
		
		switch (Reg.keyCodesCur)
		{
			case 2:	
				if (Reg.keyCodesCur != Reg.keyCodesPre) {
					dirVersor.set(0, -1);
					lookForVerticalPath();
					animation.play("walkUp");
				}
				
				
			case 3:	
				if (Reg.keyCodesCur != Reg.keyCodesPre) {
					dirVersor.set(1, 0);
					lookForHorizontalPath();				
					animation.play("walkRight");
				}
				
			case 5:	
				if (Reg.keyCodesCur != Reg.keyCodesPre) {
					dirVersor.set(0, 1);
					lookForVerticalPath();
					animation.play("walkDown");
				}	
				
			case 7:	
				if (Reg.keyCodesCur != Reg.keyCodesPre) {
					dirVersor.set(-1, 0);
					lookForHorizontalPath();
					animation.play("walkLeft");
				}
				
			default:
				dirVersor.set(0, 0);
				animation.stop();
				stopMovement();			
		}
	}
	/*
	private function lookForPathUp():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (x + origin.x == currentTileMidpoint.x)
		{
			endTile = findPath(x + width / 2, y + height / 2);
			
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
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2 + Reg.TILE_WIDTH, y + height / 2);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
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
					endTile = findPath(x + width / 2 - Reg.TILE_WIDTH, y + height / 2);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
		}
		
	}
	private function lookForPathDown():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (x + origin.x == currentTileMidpoint.x)
		{
			endTile = findPath(x + width / 2, y + height / 2);			
			moveAlongPath(endTile);
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
					endTile = findPath(x + width / 2 + Reg.TILE_WIDTH, y + height / 2);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
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
					endTile = findPath(x + width / 2 - Reg.TILE_WIDTH, y + height / 2);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
		}
		
	}
	private function lookForPathRight():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (y + origin.y == currentTileMidpoint.y)
		{
			endTile = findPath(x + width / 2, y + height / 2);
			
			moveAlongPath(endTile);
		}
		else if (y + origin.y > currentTileMidpoint.y)
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2);
			var rightTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (rightTileType == 2)
			{				
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH, y + height / 2 + Reg.TILE_HEIGHT);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
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
					endTile = findPath(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
		}
		
	}	
	private function lookForPathLeft():Void {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (y + origin.y == currentTileMidpoint.y)
		{
			endTile = findPath(x + width / 2, y + height / 2);
			
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
				
				//	trace(diagTileType);
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findPath(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT);					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
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
					endTile = findPath(x + width / 2, y + height / 2 - Reg.TILE_HEIGHT);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findPath(x + width / 2, y + height / 2);		
				moveAlongPath(endTile);
			}
			
			//	trace("MINOR || " + endTile);
		}
		
	}
	*/
	private function lookForVerticalPath() {
		var endTile:FlxPoint;
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		
		path = new FlxPath();
		
		if (getMidpoint().x == currentTileMidpoint.x)
		{
			endTile = findGoalTile(currentTileMidpoint.x, currentTileMidpoint.y);
			moveAlongPath(endTile);
			trace("DALE");
		}
		else 
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2, y + height / 2 + Reg.TILE_WIDTH * dirVersor.y);
			var nextTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (nextTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2 + Reg.TILE_WIDTH * ((x + origin.x > currentTileMidpoint.x) ? 1 : -1), y + height / 2 + Reg.TILE_HEIGHT * dirVersor.y);
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
					stopMovement();
				else
				{
					endTile = findGoalTile(x + width / 2 + Reg.TILE_WIDTH * ((x + origin.x > currentTileMidpoint.x) ? 1 : -1), y + height / 2);
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findGoalTile(x + width / 2, y + height / 2);		
				moveAlongPath(endTile, currentTileMidpoint);
			}
		}
	}
	private function lookForHorizontalPath() {
		
		var currentTileMidpoint:FlxPoint = Reg.coordinatePointToTileMidpoint(getMidpoint());
		var endTile:FlxPoint;
		path = new FlxPath();
		
		if (y + origin.y == currentTileMidpoint.y)
		{
			endTile = findGoalTile(x + width / 2, y + height / 2);
			moveAlongPath(endTile);
		}
		else 
		{
			endTile = Reg.coordinateXYToTileMidpoint(x + width / 2  + Reg.TILE_WIDTH * dirVersor.x, y + height / 2);
			var nextTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
			
			if (nextTileType == 2)
			{
				endTile = Reg.coordinateXYToTileMidpoint(x + width / 2  + Reg.TILE_WIDTH * dirVersor.x, y + height / 2 + Reg.TILE_HEIGHT * ((y + origin.y > currentTileMidpoint.y) ? 1 : -1));
				var diagTileType:Int = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(endTile));
				
				if (diagTileType == 2)
				{
					stopMovement();
				}
				else
				{
					endTile = findGoalTile(x + width / 2, y + height / 2 + Reg.TILE_HEIGHT  * ((y + origin.y > currentTileMidpoint.y) ? 1 : -1));					
					moveAlongPath(endTile);
				}
			}
			else
			{				
				endTile = findGoalTile(x + width / 2, y + height / 2);		
				moveAlongPath(endTile, currentTileMidpoint);
			}
		}
	}	
	private function findGoalTile(startingX:Float, startingY:Float):FlxPoint {
		var nextTile:FlxPoint = null;
		var nextTileType:Int;
		var i:Int = 1;
		
		do
		{
			nextTile = Reg.coordinateXYToTileMidpoint(startingX + Reg.TILE_WIDTH * i * dirVersor.x, startingY + Reg.TILE_HEIGHT * i  * dirVersor.y);
			nextTileType = Reg.collideLevel.getTileByIndex(Reg.collideLevel.getTileIndexByCoords(nextTile));
			i++;
		}
		while (nextTileType != 2);
		
		nextTile.y -= Reg.TILE_HEIGHT * dirVersor.y;
		nextTile.x -= Reg.TILE_WIDTH * dirVersor.x;
		
		//FlxG.state.add(new FlxSprite(nextTile.x, nextTile.y, AssetPaths.coin__png));
		
		return nextTile;
	}

}