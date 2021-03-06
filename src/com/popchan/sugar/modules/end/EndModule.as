﻿
package com.popchan.sugar.modules.end
{
    import com.popchan.sugar.modules.BaseModule;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.sugar.core.cfg.WindowInfo;
    import flash.geom.Point;

    public class EndModule extends BaseModule 
    {

        private static var _instance:EndModule;


        public static function getInstance():EndModule
        {
            if (_instance == null)
            {
                _instance = new (EndModule)();
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
            MsgDispatcher.add(GameEvents.OPEN_VICTORY_UI, this.showVictoryView);
            MsgDispatcher.add(GameEvents.OPEN_FAILED_UI, this.showFailedView);
            MsgDispatcher.add(GameEvents.OPEN_GAME_END_UI, this.showGameEndView);
        }

        private function showGameEndView():void
        {
            WindowManager3D.getInstance().open(WindowInfo.gameEndPanelInfo, null, false, new Point(0, 0), true);
        }

        private function showVictoryView():void
        {
            WindowManager3D.getInstance().open(WindowInfo.victoryPanelInfo, null, true);
        }

        private function showFailedView():void
        {
            WindowManager3D.getInstance().open(WindowInfo.failedPanelInfo, null, false, new Point(0, 0));
        }


    }
}
