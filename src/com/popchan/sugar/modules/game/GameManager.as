package com.popchan.sugar.modules.game
{
	import com.popchan.sugar.core.cfg.Config;
	import com.popchan.sugar.core.cfg.levels.LevelCO;
	import com.popchan.sugar.core.data.GameConst;
	
	import flash.geom.Point;

	/**
	 *
	 * 请为我写上注释，以告诉其他小伙伴我是用来做什么的
	 * @author fly.liuyang
	 * 创建时间：2017-7-4 下午9:37:56
	 * 
	 */
	public class GameManager
	{
		
		public static var currentLevel:LevelCO;
		
		public static var offsetX:int = 0;
		public static var offsetY:int = 0;
		
		public function GameManager()
		{
		}
		
		public static function newGame(level:int):void
		{
			currentLevel = Config.levelConfig.getLevel(level);
		}
		
		
		public static function getTileArr():Array
		{
			return currentLevel.tile;	
		}
//		
//		public static function getBarrierArr():Array
//		{
//			return currentLevel.barrier;	
//		}
//		
//		public static function getEntryAndExitArr():Array
//		{
//			return currentLevel.entryAndExit;	
//		}
		
		public static function getMode():int
		{
			return currentLevel.mode;	
		}
		
		public static function isBlank(row:int, col:int):Boolean
		{
			if (!isValidPos(row, col))
			{
				return true;
			}
			if (currentLevel.tile[row][col] == 0)
			{
				return true;
			}
			return false;
		}
		
		public static function isValidPos(row:int, col:int):Boolean
		{
			if (row >= 0 && row < GameConst.ROW_COUNT && col >= 0 && col < GameConst.COL_COUNT)
			{
				return true;
			}
			return false;
		}
		
		public static function getCandyPosition(row:int, col:int):Point
		{
			return (new Point(((col * GameConst.CARD_W) + offsetX), ((row * GameConst.CARD_W) + offsetY)));
		}
		
		public static function getTileValue(row:int,col:int):int
		{
			return currentLevel.tile[row][col]
		}
		
		public static function getEntryAndExitValue(row:int,col:int):int
		{
			return currentLevel.entryAndExit[row][col]
		}
		
		public static function getColorCount():int
		{
			return currentLevel.colorCount;
		}
		
	}
}