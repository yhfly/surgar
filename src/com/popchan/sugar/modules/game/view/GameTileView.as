package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.sugar.core.data.GameConst;
	import com.popchan.sugar.core.util.Utils;
	import com.popchan.sugar.modules.game.GameManager;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;

	/**
	 *
	 * 棋盘背景
	 * @author fly.liuyang
	 * 创建时间：2017-7-4 下午9:35:55
	 * 
	 */
	public class GameTileView  extends Sprite
	{
		
		public var tileBoarders:Array;
		public var tileBgs:Array;
		
		public function GameTileView()
		{
		}
		
		public function createTileBg():void
		{
			tileBgs = Utils.getBlankMapArray();
			tileBoarders = [];
			var row:int;
			var col:int;
			var _local8:*;
			var _local9:*;
			var _local10:*;
			var _local11:*;
			var _local14:int;
			var tileBg:TileBg;
			var _local16:Point;
			var tileBoarder:TileBoarder;
			var _local2:int;
			var _local3:int = (GameConst.ROW_COUNT - 1);
			var _local4:int;
			var _local5:int = (GameConst.COL_COUNT - 1);
			col = 0;
			_loop1:
			while (col < GameConst.COL_COUNT)
			{
				row = 0;
				while (row < GameConst.ROW_COUNT)
				{
					if (GameManager.getTileValue(row,col) > 0)
					{
						_local4 = col;
						break _loop1;
					}
					row++;
				}
				col++;
			}
			col = (GameConst.COL_COUNT - 1);
			_loop2:
			while (col >= 0)
			{
				row = 0;
				while (row < GameConst.ROW_COUNT)
				{
					if (GameManager.getTileValue(row,col) > 0)
					{
						_local5 = col;
						break _loop2;
					}
					row++;
				}
				col--;
			}
			row = 0;
			_loop3:
			while (row < GameConst.ROW_COUNT)
			{
				col = 0;
				while (col < GameConst.COL_COUNT)
				{
					if (GameManager.getTileValue(row,col) > 0)
					{
						_local2 = row;
						break _loop3;
					}
					col++;
				}
				row++;
			}
			row = (GameConst.ROW_COUNT - 1);
			_loop4:
			while (row >= 0)
			{
				col = 0;
				while (col < GameConst.COL_COUNT)
				{
					if (GameManager.getTileValue(row,col) > 0)
					{
						_local3 = row;
						break _loop4;
					}
					col++;
				}
				row--;
			}
			var _local12:int = ((GameConst.ROW_COUNT - _local3) - _local2);
			var _local13:int = ((GameConst.COL_COUNT - _local5) - _local4);
			GameManager.offsetX = (((Core.stage3DManager.canvasWidth - (GameConst.COL_COUNT * GameConst.CARD_W)) >> 1) + ((_local13 * GameConst.CARD_W) * 0.5));
			GameManager.offsetY = (((((Core.stage3DManager.canvasHeight - 100) - (GameConst.ROW_COUNT * GameConst.CARD_W)) >> 1) + ((_local12 * GameConst.CARD_W) * 0.5)) + 100);
			row = 0;
			while (row < GameConst.ROW_COUNT)
			{
				col = 0;
				while (col < GameConst.COL_COUNT)
				{
					_local14 = GameManager.getTileValue(row,col);
					if (_local14 > 0)
					{
						tileBg = (TileBg.pool.take() as TileBg);
						_local16 = GameManager.getCandyPosition(row, col);
						tileBg.x = _local16.x;
						tileBg.y = _local16.y;
						tileBgs[row][col] = tileBg;
						addChild(tileBg);
						if ( GameManager.isBlank(row, (col - 1)) && GameManager.isBlank((row - 1), col) && GameManager.isBlank((row - 1), (col - 1)) )
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_left_up, this, (_local16.x - 38), (_local16.y - 38));
							tileBoarders.push(tileBoarder);
						}
						if (((!(GameManager.isBlank((row + 1), (col - 1)))) && (GameManager.isBlank((row + 1), col))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_left_up_x, this, (_local16.x - 32), (_local16.y + 32));
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank(row, (col + 1))) && (GameManager.isBlank((row - 1), col)))) && (GameManager.isBlank((row - 1), (col + 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_right_up, this, (_local16.x - 3), (_local16.y - 38));
							tileBoarders.push(tileBoarder);
						}
						if (((!(GameManager.isBlank((row + 1), (col + 1)))) && (GameManager.isBlank((row + 1), col))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_right_up_x, this, (_local16.x - 4), (_local16.y + 32));
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank((row - 1), col)) && (!(GameManager.isBlank(row, (col + 1)))))) && (GameManager.isBlank((row - 1), (col + 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_heng_xia, this, _local16.x, (_local16.y - 38));
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank(row, (col - 1))) && (!(GameManager.isBlank((row + 1), col))))) && (GameManager.isBlank((row + 1), (col - 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_shu_you, this, (_local16.x - 38), _local16.y);
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank(row, (col + 1))) && (!(GameManager.isBlank((row + 1), col))))) && (GameManager.isBlank((row + 1), (col + 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_shu_zuo, this, (_local16.x + 32), _local16.y);
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank(row, (col - 1))) && (GameManager.isBlank((row + 1), col)))) && (GameManager.isBlank((row + 1), (col - 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_left_down, this, (_local16.x - 38), (_local16.y - 3));
							tileBoarders.push(tileBoarder);
						}
						if (((GameManager.isBlank(row, (col + 1))) && (!(GameManager.isBlank((row + 1), (col + 1))))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_left_down_x, this, (_local16.x + 32), (_local16.y - 4));
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank(row, (col + 1))) && (GameManager.isBlank((row + 1), col)))) && (GameManager.isBlank((row + 1), (col + 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_right_down, this, (_local16.x - 3), (_local16.y - 3));
							tileBoarders.push(tileBoarder);
						}
						if (((GameManager.isBlank(row, (col - 1))) && (!(GameManager.isBlank((row + 1), (col - 1))))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_right_down_x, this, (_local16.x - 68), (_local16.y - 4));
							tileBoarders.push(tileBoarder);
						}
						if (((((GameManager.isBlank((row + 1), col)) && (!(GameManager.isBlank(row, (col + 1)))))) && (GameManager.isBlank((row + 1), (col + 1)))))
						{
							tileBoarder = TileBoarder.pool.take();
							tileBoarder.setType(TileBoarder.x_border_heng_shang, this, _local16.x, (_local16.y + 32));
							tileBoarders.push(tileBoarder);
						}
					}
					col++;
				}
				row++;
			}
		}
		
		
		public function reset():void
		{
			Utils.removeAllElements(tileBgs, TileBg.pool);
			var _local4:TileBoarder;
			var i:int;
			i = (tileBoarders.length - 1);
			while (i >= 0)
			{
				_local4 = tileBoarders[i];
				TileBoarder.pool.put(_local4);
				_local4.removeFromParent();
				tileBoarders.splice(i, 1);
				i--;
			}
		}
	 
	}
}