
package com.popchan.sugar.modules.guide
{
    public interface IGuide 
    {

        function guideProcess(_arg1:GuideVO=null):void;
        function guideClear():void;
        function get instanceName():String;
        function set instanceName(_arg1:String):void;
        function getComponentByName(_arg1:String):void;

    }
}//package com.popchan.sugar.modules.guide
