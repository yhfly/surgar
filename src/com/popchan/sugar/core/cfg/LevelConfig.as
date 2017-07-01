package com.popchan.sugar.core.cfg
{
    import com.popchan.framework.ds.Dict;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.data.GameConst;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.framework.manager.Debug;
    import com.popchan.sugar.core.cfg.levels.*;

    public class LevelConfig implements IJsonConfig 
    {

        public static const TOTAL_LEVEL:int = 384;

        private var dict:Dict;

        public function LevelConfig()
        {
            this.dict = new Dict();
            super();
        }

        public function setUp(_arg1:Object):void
        {
        }

        public function getLevel(_arg1:int):LevelCO
        {
            var levelCO:LevelCO;
           
            var _local5:String;
         
            var _local7:int;
            var _local8:int;
            if (this.dict.contains(_arg1))
            {
                return (this.dict.take(_arg1));
            };
            var levelXml:XML = Core.texturesManager.getXml(("Level" + _arg1));
            if (levelXml != null)
            {
                levelCO = new LevelCO();
                levelCO.tile = this.convertToArray(String(levelXml.tile));
                levelCO.board = this.convertToArray(String(levelXml.board));
                levelCO.ice = this.convertToArray(String(levelXml.ice));
                levelCO.stone = this.convertToArray(String(levelXml.stone));
                levelCO.candy = this.convertToArray(String(levelXml.candy));
                levelCO.barrier = this.convertToArray(String(levelXml.barrier));
                if (levelXml.hasOwnProperty("colorCount"))
                {
                    levelCO.colorCount = int(levelXml.colorCount);
                }
                else
                {
                    levelCO.colorCount = 5;
                };
                if (levelXml.hasOwnProperty("ironWire"))
                {
                    levelCO.ironWire = this.convertToArray(String(levelXml.ironWire));
                }
                else
                {
                    levelCO.ironWire = this.getBlankArray();
                };
                if (levelXml.hasOwnProperty("eat"))
                {
                    levelCO.eat = this.convertToArray(String(levelXml.eat));
                }
                else
                {
                    levelCO.eat = this.getBlankArray();
                };
                if (levelXml.hasOwnProperty("monster"))
                {
                    levelCO.monster = this.convertToArray(String(levelXml.monster));
                }
                else
                {
                    levelCO.monster = this.getBlankArray();
                };
                levelCO.lock = this.convertToArray(String(levelXml.lock));
                levelCO.entryAndExit = this.convertToArray(String(levelXml.entryAndExit));
                levelCO.aim = String(levelXml.aim).split("|");
                levelCO.mode = levelXml.mode;
                levelCO.step = levelXml.step;
                levelCO.needScore = 0;
				var i:int = 0;
				var j:int = 0;
                while (i < GameConst.COL_COUNT)
                {
                    j = 0;
                    while (j < GameConst.ROW_COUNT)
                    {
                        if (levelCO.tile[j][i] > 0)
                        {
                            levelCO.needScore = (levelCO.needScore + 50);
                        };
                        j++;
                    };
                    i++;
                };
                for each (_local5 in levelCO.aim)
                {
                    _local7 = int(_local5.split(",")[0]);
                    _local8 = int(_local5.split(",")[1]);
                    if (_local7 != AimType.SCORE)
                    {
                        levelCO.needScore = (levelCO.needScore + (_local8 * 50));
                    };
                };
                this.dict.put(_arg1, levelCO);
            }
            else
            {
                Debug.log(("未找到关卡-" + _arg1));
            };
            return (levelCO);
        }

        private function convertToArray(_arg1:String, _arg2:String="|", _arg3:String=","):Array
        {
            var _local7:String;
            var _local8:Array;
            var _local9:int;
            var _local4:Array = [];
            var _local5:Array = _arg1.split(_arg2);
            var _local6:int;
            while (_local6 < _local5.length)
            {
                _local7 = _local5[_local6];
                _local8 = _local7.split(_arg3);
                _local4[_local6] = [];
                _local9 = 0;
                while (_local9 < _local8.length)
                {
                    _local4[_local6][_local9] = int(_local8[_local9]);
                    _local9++;
                };
                _local6++;
            };
            return (_local4);
        }

        private function getBlankArray():Array
        {
            var _local3:int;
            var _local1:Array = [];
            var _local2:int;
            while (_local2 < 9)
            {
                _local1[_local2] = [];
                _local3 = 0;
                while (_local3 < 9)
                {
                    _local1[_local2][_local3] = 0;
                    _local3++;
                };
                _local2++;
            };
            return (_local1);
        }


    }
}
