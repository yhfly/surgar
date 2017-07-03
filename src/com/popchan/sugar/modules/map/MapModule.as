
package com.popchan.sugar.modules.map
{
    import com.popchan.sugar.modules.BaseModule;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.sugar.core.cfg.WindowInfo;
    import flash.geom.Point;

    public class MapModule extends BaseModule 
    {

        private static var _instance:MapModule;


        public static function getInstance():MapModule
        {
            if (_instance == null)
            {
                _instance = new (MapModule)();
            }
            return (_instance);
        }


        override public function dispose():void
        {
            super.dispose();
        }

        override public function init():void
        {
            super.init();
            MsgDispatcher.add(GameEvents.OPEN_MAP_UI, this.openMapUI);
        }

        private function openMapUI():void
        {
            WindowManager3D.getInstance().open(WindowInfo.mapPanelInfo, null, false, new Point(0, 0));
        }


    }
}