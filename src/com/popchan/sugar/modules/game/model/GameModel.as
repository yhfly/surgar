
package com.popchan.sugar.modules.game.model
{
    import flash.utils.Dictionary;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.Model;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.sugar.core.data.AimType;

    public class GameModel 
    {

        private var aim:Dictionary;
        private var aimOrg:Dictionary;
        private var _step:int;
        private var _time:int;
        private var _score:int;
        public var highScore:int;
        public var isSuccess:Boolean;

        public function GameModel()
        {
            this.aim = new Dictionary();
            this.aimOrg = new Dictionary();
            super();
        }

        public function get score():int
        {
            return (this._score);
        }

        public function set score(_arg1:int):void
        {
            this._score = _arg1;
            MsgDispatcher.execute(GameEvents.SCORE_CHANGE);
        }

        public function get time():int
        {
            return (this._time);
        }

        public function set time(_arg1:int):void
        {
            this._time = _arg1;
            if (Model.settingModel.isWudiBan)
            {
                this._time = 999;
            }
            MsgDispatcher.execute(GameEvents.TIME_CHANGE);
            if (_arg1 <= 10)
            {
                SoundManager.instance.playSound("warningtime");
            }
        }

        public function get step():int
        {
            return (this._step);
        }

        public function set step(_arg1:int):void
        {
            this._step = _arg1;
            if (Model.settingModel.isWudiBan)
            {
                this._step = 999;
            }
            if (this._step <= 5)
            {
                SoundManager.instance.playSound("warningmove");
            }
            MsgDispatcher.execute(GameEvents.STEP_CHANGE);
        }

        public function reset():void
        {
            var _local1:*;
            for (_local1 in this.aim)
            {
                delete this.aim[_local1];
            }
            for (_local1 in this.aimOrg)
            {
                delete this.aimOrg[_local1];
            }
            this.isSuccess = false;
            this.score = 0;
        }

        public function addAim(_arg1:int, _arg2:int):void
        {
            this.aim[_arg1] = 0;
            this.aimOrg[_arg1] = _arg2;
        }

        public function offsetAim(_arg1:int, _arg2:int):void
        {
            if (this.aim[_arg1] != undefined)
            {
                this.aim[_arg1] = (this.aim[_arg1] + _arg2);
                if (this.aim[_arg1] >= this.aimOrg[_arg1])
                {
                    this.aim[_arg1] = this.aimOrg[_arg1];
                }
                MsgDispatcher.execute(GameEvents.AIMS_CHANGE, {
                    "type":_arg1,
                    "value":this.aim[_arg1],
                    "orgValue":this.aimOrg[_arg1]
                });
            }
        }

        public function getLeftFruitAim(_arg1:Array):Array
        {
            var _local3:int;
            var _local4:*;
            var _local5:int;
            var _local2:Array = [];
            for (_local4 in this.aim)
            {
                if ((((((_local4 == AimType.FRUIT1)) || ((_local4 == AimType.FRUIT2)))) || ((_local4 == AimType.FRUIT3))))
                {
                    _local3 = 0;
                    while (_local3 < (this.aimOrg[_local4] - this.aim[_local4]))
                    {
                        _local2.push(_local4);
                        _local3++;
                    }
                }
            }
            _local3 = 0;
            while (_local3 < _arg1.length)
            {
                _local5 = (_local2.length - 1);
                while (_local5 >= 0)
                {
                    if (_local2[_local5] == _arg1[_local3])
                    {
                        _local2.splice(_local5, 1);
                    }
                    _local5--;
                }
                _local3++;
            }
            return (_local2);
        }

        public function checkAimComplete():Boolean
        {
            var _local2:*;
            var _local1:Boolean = true;
            for (_local2 in this.aim)
            {
                if (this.aim[_local2] < this.aimOrg[_local2])
                {
                    _local1 = false;
                    break;
                }
            }
            return (_local1);
        }

        public function isScoreAimLevel():Boolean
        {
            var _local1:*;
            for (_local1 in this.aim)
            {
                if (_local1 == AimType.SCORE)
                {
                    return true;
                }
            }
            return false;
        }


    }
} 