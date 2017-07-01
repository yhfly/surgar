
package com.popchan.sugar.modules.map.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.modules.map.vo.LevelVO;
    
    import starling.display.Button;
    import starling.display.CMovieClip;
    import starling.display.Sprite;
    import starling.display.TextSprite;
    import starling.events.Event;

	/**
	 *  
	 * @author admin
	 * 
	 */	
    public class LevelItem extends Sprite 
    {

        public var btn:Button;
        private var _levelId:int;

        public function LevelItem($levelId:int)
        {
            super();
            var levelVO:LevelVO;
            var cMovieClip:CMovieClip;
          	_levelId = $levelId;
            var currentLevel:int = Model.levelModel.currentLevel;
            if ($levelId <= currentLevel)
            {
                if ($levelId == currentLevel)
                {
                   btn = ToolKit.createButton(this, Core.texturesManager.getTexture("lv_current"), 0, 0, null);
                    cMovieClip = new CMovieClip(Core.texturesManager.getTextures("e_current"), 12);
                    cMovieClip.touchable = false;
                    cMovieClip.gotoAndPlay(1);
                    addChild(cMovieClip);
                }
                else
                {
                   btn = ToolKit.createButton(this, Core.texturesManager.getTexture("lv_pass"), 0, 0, null);
                }
                addChild(this.btn);
                levelVO = Model.levelModel.getLevelVO($levelId);
                if (levelVO.star > 0)
                {
                    ToolKit.createImage(this, Core.texturesManager.getTexture(("star" + levelVO.star)), -50, -63, false, false);
                }
            }
            else
            {
               btn = ToolKit.createButton(this, Core.texturesManager.getTexture("lv_lock"), 0, 0, null);
               addChild(this.btn);
               btn.touchable = false;
            }
           btn.x = (-(this.btn.width) >> 1);
           btn.y = (-(this.btn.height) >> 1);
            var textSprite:TextSprite = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("lvfont_"), 0, 31, 16);
            textSprite.text = ($levelId + "");
            textSprite.pivotX = (textSprite.width >> 1);
            textSprite.pivotY = (textSprite.height >> 1);
        }

		public function get levelId():int
		{
			return _levelId;
		}

        private function onBtnTouch(_arg1:Event):void
        {
        }

        public function setOpen(isOpen:Boolean):void
        {
           btn.touchable = isOpen;
        }


    }
} 