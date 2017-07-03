
package com.popchan.framework.ds
{
    import flash.utils.Dictionary;

    public class Dict 
    {

        public var result:Array;
        private var _weak:Boolean;
        private var _dict:Dictionary;
        private var _size:int;

        public function Dict(_arg1:Boolean=false)
        {
            this.result = new Array();
            super();
            this._dict = new Dictionary(_arg1);
            this._size = 0;
            this._weak = _arg1;
        }

        public function put(_arg1:*, _arg2:*):void
        {
            if (_arg2 === undefined)
            {
                return;
            }
            if (this._dict[_arg1] === undefined)
            {
                this._size++;
            }
            this._dict[_arg1] = _arg2;
        }

        public function take(_arg1:*):*
        {
            return (this._dict[_arg1]);
        }

        public function remove(_arg1:*):*
        {
            if (this._dict[_arg1] !== undefined)
            {
                this._size--;
            }
            var _local2:* = this._dict[_arg1];
            delete this._dict[_arg1];
            return (_local2);
        }

        public function clear():void
        {
            this._dict = new Dictionary(this._weak);
            this._size = 0;
        }

        public function dispose():void
        {
            this._dict = null;
        }

        public function get size():int
        {
            var _local1:int;
            var _local2:*;
            if (this._weak)
            {
                for (_local2 in this._dict)
                {
                    _local1++;
                }
                return (_local1);
            }
            return (this._size);
        }

        public function isEmpty():Boolean
        {
            var _local1:*;
            if (this._weak)
            {
                for (_local1 in this._dict)
                {
                    return false;
                }
                return true;
            }
            return ((this._size == 0));
        }

        public function contains(_arg1:*):Boolean
        {
            return (!((this._dict[_arg1] === undefined)));
        }

        public function toArray():Array
        {
            var _local2:*;
            var _local1:Array = new Array();
            for each (_local2 in this._dict)
            {
                _local1.push(_local2);
            }
            return (_local1);
        }

        public function copy():Dict
        {
            var _local1:Dict = new Dict();
            _local1._dict = this._dict;
            _local1._size = this._size;
            _local1._weak = _local1._weak;
            return (_local1);
        }

        public function clone(_arg1:Boolean=false):Dict
        {
            var _local3:*;
            var _local2:Dict = new Dict(_arg1);
            for (_local3 in this._dict)
            {
                _local2.put(_local3, this._dict[_local3]);
            }
            return (_local2);
        }

        public function get dict():Dictionary
        {
            return (this._dict);
        }

        public function set dict(_arg1:Dictionary):void
        {
            var _local2:int;
            var _local3:*;
            this._dict = _arg1;
            for (_local3 in this._dict)
            {
                _local2++;
            }
            this._size = _local2;
        }


    }
}//package com.popchan.framework.ds
