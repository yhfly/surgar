
package com.popchan.framework.manager
{
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import flash.events.Event;
    import com.popchan.framework.core.Core;

    public class TimerManager 
    {

        private static var _instance:TimerManager;

        private var _listeners:Dictionary;
        private var _count:int;
        private var _isRunning:Boolean;

        public function TimerManager()
        {
            this._listeners = new Dictionary();
            super();
        }

        public function add(_arg1:*, _arg2:Function, _arg3:int, _arg4:int=-1, _arg5:Object=null):void
        {
            var _local7:TimeModel;
            var _local8:TimeModel;
            var _local6:Array = this._listeners[_arg1];
            if (_local6 == null)
            {
                _local6 = [];
            }
            else
            {
                for each (_local8 in _local6)
                {
                    if (_local8.callBack == _arg2)
                    {
                        return;
                    }
                }
            }
            _local7 = new TimeModel();
            _local7.callBack = _arg2;
            _local7.target = _arg1;
            _local7.delay = _arg3;
            _local7.repeatCount = _arg4;
            _local7.params = _arg5;
            _local7.currentCount = 0;
            _local7.currentTime = getTimer();
            _local7.offset = 0;
            _local6.push(_local7);
            this._listeners[_arg1] = _local6;
            this._count++;
            this.resume();
        }

        public function remove(_arg1:*, _arg2:Function):void
        {
            var _local3:Array = this._listeners[_arg1];
            if (_local3 == null)
            {
                return;
            }
            var _local4:int;
            while (_local4 < _local3.length)
            {
                if (_local3[_local4].callBack == _arg2)
                {
                    _local3[_local4].isRemoved = true;
                    _local3.splice(_local4, 1);
                    this._count--;
                    _local4--;
                }
                _local4++;
            }
            if (this._count == 0)
            {
                this.pause();
            }
        }

        protected function onEnterFrame(_arg1:Event):void
        {
            var _local2:*;
            var _local3:Array;
            var _local4:TimeModel;
            var _local5:int;
            for (_local2 in this._listeners)
            {
                _local3 = this._listeners[_local2];
                for each (_local4 in _local3)
                {
                    _local5 = (getTimer() - _local4.currentTime);
                    _local4.offset = (_local4.offset + _local5);
                    _local4.currentTime = getTimer();
                    if (_local4.offset >= _local4.delay)
                    {
                        while (_local4.offset >= _local4.delay)
                        {
                            if (_local4.isRemoved) break;
                            _local4.offset = (_local4.offset - _local4.delay);
                            _local4.currentCount++;
                            if (_local4.repeatCount > 0)
                            {
                                if (_local4.params == null)
                                {
                                    _local4.callBack();
                                }
                                else
                                {
                                    _local4.callBack(_local4.params);
                                }
                                if (_local4.currentCount == _local4.repeatCount)
                                {
                                    this.remove(_local4.target, _local4.callBack);
                                    break;
                                }
                            }
                            else
                            {
                                if (_local4.params == null)
                                {
                                    _local4.callBack();
                                }
                                else
                                {
                                    _local4.callBack(_local4.params);
                                }
                            }
                        }
                    }
                }
            }
        }

        public function pause():void
        {
            if (this._isRunning)
            {
                this._isRunning = false;
                Core.stageManager.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
        }

        public function resume():void
        {
            if (((!(this._isRunning)) && ((this._count > 0))))
            {
                this._isRunning = true;
                Core.stageManager.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
        }


    }
}//package com.popchan.framework.manager

class TimeModel 
{

    public var callBack:Function;
    public var target:*;
    public var params:Object;
    public var delay:int;
    public var repeatCount:int;
    public var offset:int;
    public var currentTime:int;
    public var currentCount:int;
    public var isRemoved:Boolean;


}
class Single 
{


}
