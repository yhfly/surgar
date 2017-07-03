
package com.popchan.sugar.modules.guide
{
    import com.popchan.sugar.modules.BaseModule;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.cfg.Config;
    import __AS3__.vec.Vector;

    public class GuideModule extends BaseModule 
    {

        private static var _instance:GuideModule;


        public static function getInstance():GuideModule
        {
            if (_instance == null)
            {
                _instance = new (GuideModule)();
            }
            return (_instance);
        }


        override public function dispose():void
        {
            super.dispose();
            MsgDispatcher.remove(GameEvents.OPEN_GUIDE, this.doGuide);
        }

        override public function init():void
        {
            super.init();
            MsgDispatcher.add(GameEvents.OPEN_GUIDE, this.doGuide);
        }

        private function doGuide(guideId:int):void
        {
            var guideStep:Vector.<GuideVO> = Config.guideConfig.getGuideList(guideId);
            GuideManager.instance.setUp(guideStep);
            GuideManager.instance.start();
        }


    }
}//package com.popchan.sugar.modules.guide
