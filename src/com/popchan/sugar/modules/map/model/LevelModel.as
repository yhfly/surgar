
package com.popchan.sugar.modules.map.model
{
    import com.popchan.sugar.modules.map.vo.LevelVO;
    import com.popchan.framework.utils.DataUtil;
    import com.popchan.framework.utils.Base64;

    public class LevelModel 
    {

        public var currentLevel:int = 1;
        public var selectedLevel:int = 1;
        private var levelsMap:Object;
        public var totalLevel:int = 200;

        public function LevelModel()
        {
            levelsMap = {};
            super();
        }

        public function getLevelVO(levelId:int):LevelVO
        {
            var levelVO:LevelVO;
            if (levelsMap[levelId] == null)
            {
                levelVO = new LevelVO();
                levelVO.id = levelId;
                levelVO.star = 0;
                levelVO.highscore = 0;
                levelsMap[levelVO.id] = levelVO;
            }
            return (levelsMap[levelId]);
        }

        public function loadData():void
        {
            var mapScoreArr:Array;
            var infoStr:String;
            var infoArr:Array;
            var levelVO:LevelVO;
            var baseStr:String = DataUtil.readString("levels", "");
            baseStr = Base64.decode(baseStr);
            if (baseStr.length > 0)
            {
                mapScoreArr = baseStr.split("|");
	            var i:int = 0;
                while (i < mapScoreArr.length)
                {
                    infoStr = mapScoreArr[i];
                    infoArr = infoStr.split("&");
                    levelVO = new LevelVO();
                    levelVO.id = int(infoArr[0]);
                    levelVO.star = int(infoArr[1]);
                    levelVO.highscore = int(infoArr[2]);
                    levelsMap[levelVO.id] = levelVO;
                    i++;
                }
            }
            currentLevel = DataUtil.readInt("currentLevel", 1);
        }

        public function getTotalScore():Number
        {
            var levelVO:LevelVO;
            var score:Number = 0;
            for each (levelVO in levelsMap)
            {
                score = (score + levelVO.highscore);
            }
            return score;
        }

        public function saveData():void
        {
            var levelVO:LevelVO;
            var _local3:String;
            DataUtil.writeInt("currentLevel", currentLevel);
            var _local1:Array = [];
            for each (levelVO in levelsMap)
            {
                _local1.push(((((levelVO.id + "&") + levelVO.star) + "&") + levelVO.highscore));
            }
            _local3 = _local1.join("|");
            _local3 = Base64.encode(_local3);
            DataUtil.writeString("levels", _local3);
            DataUtil.save(DataUtil.id);
        }


    }
}