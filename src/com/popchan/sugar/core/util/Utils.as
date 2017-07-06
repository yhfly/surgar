package com.popchan.sugar.core.util
{
	import com.popchan.framework.ds.BasePool;
	import com.popchan.sugar.core.data.GameConst;
	import com.popchan.sugar.modules.game.view.Element;

	/**
	 *
	 * 请为我写上注释，以告诉其他小伙伴我是用来做什么的
	 * @author fly.liuyang
	 * 创建时间：2017-7-4 下午9:57:30
	 * 
	 */
	public class Utils
	{
		public function Utils()
		{
		}
		
		public static  function removeAllElements(elementArr:Array, pool:BasePool):void
		{
			var col:int;
			var element:Element;
			var row:int;
			while (row < GameConst.ROW_COUNT)
			{
				col = 0;
				while (col < GameConst.COL_COUNT)
				{
					element = elementArr[row][col];
					if (element != null)
					{
						element.reset();
						pool.put(element);
						element.removeFromParent();
						elementArr[row][col] = null;
					}
					col++;
				}
				row++;
			}
		}
		
		
		public static function getBlankMapArray():Array
		{
			var j:int;
			var blankMapArray:Array = [];
			var i:int;
			while (i < GameConst.ROW_COUNT)
			{
				blankMapArray[i] = [];
				j = 0;
				while (j < GameConst.COL_COUNT)
				{
					blankMapArray[i][j] = null;
					j++;
				}
				i++;
			}
			return blankMapArray;
		}
		
	}
}