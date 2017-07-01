
package com.popchan.sugar.modules.game
{
    import com.popchan.sugar.modules.BaseModule;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.sugar.core.cfg.WindowInfo;
    import flash.geom.Point;

    public class GameModule extends BaseModule 
    {

        private static var _instance:GameModule;


        public static function getInstance():GameModule
        {
            if (_instance == null)
            {
                _instance = new (GameModule)();
            };
            return (_instance);
        }


        override public function dispose():void
        {
            super.dispose();
        }

        override public function init():void
        {
            MsgDispatcher.add(GameEvents.OPEN_GAME_UI, this.openGameUI);
            MsgDispatcher.add(GameEvents.OPEN_MISSION_UI, this.openMissionUI);
            MsgDispatcher.add(GameEvents.OPEN_PAUSE_UI, this.openPauseUI);
        }

        private function openPauseUI():void
        {
            WindowManager3D.getInstance().open(WindowInfo.pausePanelInfo, null, false, new Point(0, 0), true);
        }

        private function openMissionUI():void
        {
            WindowManager3D.getInstance().open(WindowInfo.missionPanelInfo, null, false, new Point(0, 0));
        }

        private function openGameUI():void
        {
            WindowManager3D.getInstance().open(WindowInfo.gamePanelInfo, null, false, new Point(0, 0));
        }


    }
}