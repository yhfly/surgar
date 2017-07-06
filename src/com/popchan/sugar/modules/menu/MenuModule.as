
package com.popchan.sugar.modules.menu
{
    import com.popchan.sugar.modules.BaseModule;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.sugar.core.cfg.WindowInfo;
    import flash.geom.Point;

    public class MenuModule extends BaseModule 
    {

        private static var _instance:MenuModule;


        public static function getInstance():MenuModule
        {
            if (_instance == null)
            {
                _instance = new (MenuModule)();
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
            MsgDispatcher.add(GameEvents.OPEN_MENU_UI, this.openUI);
        }

        private function openUI():void
        {
            WindowManager3D.getInstance().open(WindowInfo.menuPanelInfo, null, false, new Point(0, 0));
        }
    }
} 