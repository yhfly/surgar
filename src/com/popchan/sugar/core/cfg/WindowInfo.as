package com.popchan.sugar.core.cfg
{
    import com.popchan.sugar.modules.menu.view.MenuPanel;
    import com.popchan.sugar.modules.game.view.panel.GamePanel;
    import com.popchan.sugar.modules.end.view.GameEndPanel;
    import com.popchan.sugar.modules.end.view.VictoryPanel;
    import com.popchan.sugar.modules.end.view.FailedPanel;
    import com.popchan.sugar.modules.map.view.MapPanel;
    import com.popchan.sugar.modules.game.view.panel.MissonPanel;
    import com.popchan.sugar.modules.game.view.panel.PausePanel;

    public class WindowInfo 
    {

        public static var menuPanelInfo:Array = ["menuPanel", MenuPanel];
        public static var gamePanelInfo:Array = ["gamePanel", GamePanel];
        public static var gameEndPanelInfo:Array = ["gameEndPanel", GameEndPanel];
        public static var victoryPanelInfo:Array = ["victoryPanel", VictoryPanel];
        public static var failedPanelInfo:Array = ["failedPanel", FailedPanel];
        public static var mapPanelInfo:Array = ["mapPanel", MapPanel];
        public static var missionPanelInfo:Array = ["missionPanel", MissonPanel];
        public static var pausePanelInfo:Array = ["pausePanel", PausePanel];


    }
} 
