
package com.popchan.framework.core
{
    import com.popchan.framework.ds.Dict;
    
    import __AS3__.vec.Vector;

    public class MsgDispatcher 
    {

        private static var dict:Dict = new Dict();


        public static function add(type:String, func:Function):void
        {
            var callFuncVec:Vector.<Function> = dict.take(type);
            if (callFuncVec)
            {
                if (callFuncVec.indexOf(func) != -1)
                {
                    return;
                }
            }
            else
            {
                callFuncVec = new Vector.<Function>();
                dict.put(type, callFuncVec);
            }
            callFuncVec.push(func);
        }

        public static function remove(type:String, func:Function):void
        {
            if (!dict.contains(type))
            {
                return;
            }
            var callFuncVec:Vector.<Function> = dict.take(type);
            if (!callFuncVec)
            {
                return;
            }
            var _local4:int = callFuncVec.indexOf(func);
            if (_local4 != -1)
            {
                callFuncVec.splice(_local4, 1);
            }
            if (callFuncVec.length <= 0)
            {
                dict.remove(type);
            }
        }

        public static function execute(type:String, ... _args):void
        {
            var func:Function;
            var callFuncVec:Vector.<Function> = dict.take(type);
            if (callFuncVec != null)
            {
                callFuncVec = callFuncVec.concat();
            }
            for each (func in callFuncVec)
            {
                func.apply(null, _args);
            }
        }


    }
}//package com.popchan.framework.core
