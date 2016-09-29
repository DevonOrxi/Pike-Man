package;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;

class Reg
{	
	static public var playerSpeed:Int = 100;
	static public var collideLevel:FlxTilemap;
	static public var keyCodesCur:Int = 1;
	static public var keyCodesPre:Int = 1;	
	
	inline static public var TILE_HEIGHT:Int = 16;
	inline static public var TILE_WIDTH:Int = 16;
	inline static public var CODEVALUE_UP:Int = 2;
	inline static public var CODEVALUE_RIGHT:Int = 3;
	inline static public var CODEVALUE_DOWN:Int = 5;
	inline static public var CODEVALUE_LEFT:Int = 7;

	//	Uses x and y to calculate the tile row and column as a FlxPoint.
	static public function coordinateXYToCR(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH), Std.int(Y / TILE_HEIGHT))); }

	//	Uses a FlxPoint to calculate the tile row and column as a FlxPoint.
	static public function coordinatePointToCR(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH), Std.int(c.y / TILE_HEIGHT))); }

	//	Uses x and y to calculate the tile zero position as a FlxPoint.
	static public function coordinateXYToTilePoint(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH) * TILE_WIDTH, Std.int(Y / TILE_HEIGHT) * TILE_HEIGHT)); }

	//	Uses a FlxPoint to calculate the tile zero position as a FlxPoint.
	static public function coordinatePointToTilePoint(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH) * TILE_WIDTH, Std.int(c.y / TILE_HEIGHT) * TILE_HEIGHT));	}

	//	Uses x and y to calculate the tile midpoint as a FlxPoint.
	static public function coordinateXYToTileMidpoint(X:Float, Y:Float):FlxPoint { return (FlxPoint.get(Std.int(X / TILE_WIDTH) * TILE_WIDTH + TILE_WIDTH / 2, Std.int(Y / TILE_HEIGHT) * TILE_HEIGHT + TILE_HEIGHT / 2));	}

	//	Uses a FlxPoint to calculate the tile midpoint as a FlxPoint.
	static public function coordinatePointToTileMidpoint(c:FlxPoint):FlxPoint { return (FlxPoint.get(Std.int(c.x / TILE_WIDTH) * TILE_WIDTH + TILE_WIDTH / 2, Std.int(c.y / TILE_HEIGHT) * TILE_HEIGHT + TILE_HEIGHT / 2));	 }

}