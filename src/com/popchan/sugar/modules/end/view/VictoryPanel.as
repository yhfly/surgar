
package com.popchan.sugar.modules.end.view
{
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.modules.map.vo.LevelVO;

    public class VictoryPanel extends BasePanel3D 
    {
        override public function init():void
        {
            super.init();
            var image:Image = new Image(Texture.fromTexture(Core.texturesManager.getTexture("dialogsuccess")));
            addChild(image);
        }

        override public function show(data:*):void
        {
            super.show(data);
            if (Model.levelModel.currentLevel == Model.levelModel.selectedLevel)
            {
                Model.levelModel.currentLevel++;
                if (Model.levelModel.currentLevel > Model.levelModel.totalLevel)
                {
                    Model.levelModel.currentLevel = Model.levelModel.totalLevel;
                }
            }
            var star:int = 2;
            var levelVO:LevelVO = Model.levelModel.getLevelVO(Model.levelModel.selectedLevel);
            levelVO.star = star;
            levelVO.highscore = Model.gameModel.highScore;
            Model.levelModel.saveData();
        }
    }
} 