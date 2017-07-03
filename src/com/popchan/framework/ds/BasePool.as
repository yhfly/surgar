
package com.popchan.framework.ds
{
    public class BasePool 
    {

        protected var _cacheClass:Class;
        protected var _maxCacheNum:int;
        protected var _curCacheNum:int;
        protected var _usingNum:int;
        protected var _storeNum:int;
        protected var _storeList:Array;
        protected var _params:Array;

        public function BasePool(_arg1:Class, _arg2:int, _arg3:Array=null)
        {
            this._storeList = new Array();
            super();
            this._cacheClass = _arg1;
            this._maxCacheNum = _arg2;
            this._params = _arg3;
        }

        public function take():*
        {
            var _local1:*;
            if (this._storeList.length > 0)
            {
                return (this._storeList.shift());
            }
            return (new this._cacheClass());
        }

        public function put(_arg1:*):Boolean
        {
            if (_arg1 == null)
            {
                return false;
            }
            if (this._storeList.length > this._maxCacheNum)
            {
                return false;
            }
            if (this._storeList.indexOf(_arg1) > 0)
            {
                return false;
            }
            this._storeList.push(_arg1);
            return true;
        }

        public function isEmpty():Boolean
        {
            return ((this._storeList.length == 0));
        }

        public function get size():int
        {
            return (this._storeList.length);
        }

        public function dispose():void
        {
            this._storeList.length = 0;
            this._storeList = null;
        }


    }
}//package com.popchan.framework.ds
