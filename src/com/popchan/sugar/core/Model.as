
package com.popchan.sugar.core
{
    import com.popchan.sugar.modules.game.model.GameModel;
    import com.popchan.sugar.modules.map.model.LevelModel;
    import com.popchan.sugar.modules.menu.model.SettingModel;

    public class Model 
    {

        public static var gameModel:GameModel = new GameModel();
        public static var levelModel:LevelModel = new LevelModel();
        public static var settingModel:SettingModel = new SettingModel();


        public static function init():void
        {
        }


    }
}//package com.popchan.sugar.core
