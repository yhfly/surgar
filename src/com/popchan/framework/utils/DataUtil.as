
package com.popchan.framework.utils
{
    import flash.net.SharedObject;

	/**
	 * 本地数据缓存 
	 * @author admin
	 * 
	 */	
    public class DataUtil 
    {
        private static const DEFAULT_FILE:String = "_file";
        private static const SIZE:uint = 10000;

        public static var id:String = "fdfd";
        private static var _shared:SharedObject;
        private static var _data:Object = {};
        public static var prefix:String = "FlashPunk";


        public static function load(dataId:String=""):void
        {
            var _local3:String;
            var _local2:Object = loadData(dataId);
            _data = {};
            for (_local3 in _local2)
            {
                _data[_local3] = _local2[_local3];
            }
        }

        public static function save(_arg1:String=""):void
        {
            var _local3:String;
            if (_shared)
            {
                _shared.clear();
            }
            var _local2:Object = loadData(_arg1);
            for (_local3 in _data)
            {
                _local2[_local3] = _data[_local3];
            }
            _shared.flush(SIZE);
        }

        public static function readInt(key:String, defaultValue:int=0):int
        {
            return (int(read(key, defaultValue)));
        }

        public static function readUint(key:String, defaultValue:uint=0):uint
        {
            return (uint(read(key, defaultValue)));
        }

        public static function readObj(key:String, defaultValue:Object=null):Object
        {
            return (read(key, defaultValue));
        }

        public static function readBool(key:String, defaultValue:Boolean=true):Boolean
        {
            return (Boolean(read(key, defaultValue)));
        }

        public static function readString(key:String, defaultValue:String=""):String
        {
            return (String(read(key, defaultValue)));
        }

        public static function writeInt(key:String, value:int=0):void
        {
            _data[key] = value;
        }

        public static function writeUint(key:String, value:uint=0):void
        {
            _data[key] = value;
        }

        public static function writeBool(key:String, value:Boolean=true):void
        {
            _data[key] = value;
        }

        public static function writeObj(key:String, value:*):void
        {
            _data[key] = value;
        }

        public static function writeString(key:String, value:String=""):void
        {
            _data[key] = value;
        }

        private static function read(key:String, value:*):*
        {
            if (_data.hasOwnProperty(key))
            {
                return (_data[key]);
            }
            return (value);
        }

        private static function loadData(key:String):Object
        {
            if (!key)
            {
                key = DEFAULT_FILE;
            }
            if (id)
            {
                _shared = SharedObject.getLocal(((((prefix + "/") + id) + "/") + key), "/");
            }
            else
            {
                _shared = SharedObject.getLocal(((prefix + "/") + key));
            }
            return (_shared.data);
        }


    }
}