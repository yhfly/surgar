
package com.popchan.sugar.modules.game.view
{
    import starling.display.Sprite;
    import starling.display.TextSprite;
    import starling.display.Button;
    import starling.display.Image;
    import flash.utils.Dictionary;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.sugar.core.data.GameMode;
    import starling.textures.Texture;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import flash.geom.Point;

    public class InfoPanel extends Sprite 
    {

        private var score_txt:TextSprite;
        private var stepLabel:TextSprite;
        private var timeLabel:TextSprite;
        private var levelLabel:TextSprite;
        private var pause_btn:Button;
        private var timeIcon:Image;
        private var stepIcon:Image;
        private var progress:HProgressBar;
        private var aimLabelDict:Dictionary;
        private var aimIconDict:Dictionary;
        private var scoreAim:int;

        public function InfoPanel()
        {
            this.aimLabelDict = new Dictionary();
            this.aimIconDict = new Dictionary();
            super();
            this.progress = new HProgressBar(Core.texturesManager.getTexture("progressBg"), Core.texturesManager.getTexture("progressBar"));
            this.progress.x = 412;
            this.progress.y = 67;
            this.addChild(this.progress);
            this.progress.ratio = 0;
            this.pause_btn = ToolKit.createButton(this, Core.texturesManager.getTexture("pause_btn"), 589, 70, this.onPause);
            ToolKit.createImage(this, Core.texturesManager.getTexture("infopanel"), 0, 0, false, false);
            this.stepIcon = ToolKit.createImage(this, Core.texturesManager.getTexture("step"), 104, 20, true, false);
            this.timeIcon = ToolKit.createImage(this, Core.texturesManager.getTexture("clock"), 104, 23, true, false);
            ToolKit.createImage(this, Core.texturesManager.getTexture("score"), 539, 20, true, false);
            this.stepLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 104, 30, 16, "0123456789/x+-", 24);
            this.stepLabel.hAlign = "center";
            this.timeLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 104, 30, 16, "0123456789/x+-", 24);
            this.timeLabel.hAlign = "center";
            this.score_txt = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 539, 30, 16, "0123456789/x+-", 24);
            this.score_txt.hAlign = "center";
            this.score_txt.text = "0";
            ToolKit.createImage(this, Core.texturesManager.getTexture("levelimg"), 316, 80, true, false);
            this.levelLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("glevel_"), 378, 68, 18, "0123456789", 27);
            this.levelLabel.hAlign = "center";
            MsgDispatcher.add(GameEvents.AIMS_CHANGE, this.onAimChange);
            MsgDispatcher.add(GameEvents.SCORE_CHANGE, this.onScoreChange);
            MsgDispatcher.add(GameEvents.STEP_CHANGE, this.onStepChange);
            MsgDispatcher.add(GameEvents.TIME_CHANGE, this.onTimeChange);
        }

        private function onTimeChange():void
        {
            this.timeLabel.text = (Model.gameModel.time + "");
        }

        private function onPause():void
        {
            MsgDispatcher.execute(GameEvents.OPEN_PAUSE_UI);
        }

        private function onAimChange(_arg1:Object):void
        {
            if (_arg1.type == AimType.SCORE)
            {
                return;
            };
            this.aimLabelDict[_arg1.type].text = ((_arg1.orgValue - _arg1.value) + "");
        }

        private function onScoreChange():void
        {
            this.score_txt.text = (Model.gameModel.score + "");
            this.progress.ratio = (Model.gameModel.score / (this.scoreAim * 6));
        }

        private function onStepChange():void
        {
            this.stepLabel.text = (Model.gameModel.step + "");
        }

        public function setInfo(_arg1:LevelCO):void
        {
            var _local2:Image;
            var _local3:*;
            var _local6:TextSprite;
            var _local7:Array;
            var _local8:int;
            var _local9:int;
            var _local10:TextSprite;
            this.scoreAim = _arg1.needScore;
            this.levelLabel.text = (Model.levelModel.selectedLevel + "");
            for (_local3 in this.aimIconDict)
            {
                _local2 = this.aimIconDict[_local3];
                _local2.removeFromParent(true);
                _local2 = null;
                delete this.aimIconDict[_local3];
            };
            for (_local3 in this.aimLabelDict)
            {
                _local6 = this.aimLabelDict[_local3];
                _local6.removeFromParent(true);
                _local6 = null;
                delete this.aimLabelDict[_local3];
            };
            if (_arg1.mode == GameMode.NORMAL)
            {
                this.stepLabel.visible = true;
                this.timeLabel.visible = false;
                Model.gameModel.step = _arg1.step;
                this.stepIcon.visible = true;
                this.timeIcon.visible = false;
            }
            else
            {
                if (_arg1.mode == GameMode.TIME)
                {
                    this.stepLabel.visible = false;
                    this.timeLabel.visible = true;
                    Model.gameModel.time = _arg1.step;
                    this.stepIcon.visible = false;
                    this.timeIcon.visible = true;
                };
            };
            var _local4:int;
            if (_arg1.aim.length == 1)
            {
                _local4 = 300;
            }
            else
            {
                if (_arg1.aim.length == 2)
                {
                    _local4 = 240;
                }
                else
                {
                    if (_arg1.aim.length == 3)
                    {
                        _local4 = 200;
                    };
                };
            };
            var _local5:int;
            while (_local5 < _arg1.aim.length)
            {
                _local7 = _arg1.aim[_local5].split(",");
                _local8 = int(_local7[0]);
                _local9 = int(_local7[1]);
                Model.gameModel.addAim(_local8, _local9);
                _local2 = new Image(Texture.fromTexture(Core.texturesManager.getTexture(AimType.AIM_ICONS[_local8])));
                _local2.pivotY = (_local2.height >> 1);
                if (_local8 != AimType.SCORE)
                {
                    _local2.pivotX = (_local2.width >> 1);
                    _local2.scaleX = (_local2.scaleY = 0.6);
                }
                else
                {
                    _local2.pivotX = _local2.width;
                };
                _local2.x = ((_local4 + (_local5 * 80)) + 30);
                _local2.y = 31;
                this.addChild(_local2);
                this.aimIconDict[_local8] = _local2;
                _local10 = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 0, 0, 16, "0123456789/x+-");
                addChild(_local10);
                _local10.text = (_local9 + "");
                _local10.x = ((_local4 + 45) + (_local5 * 80));
                _local10.y = 23;
                this.aimLabelDict[_local8] = _local10;
                _local5++;
            };
        }

        public function getIconPos(_arg1:int):Point
        {
            if (this.aimIconDict[_arg1] != undefined)
            {
                return (new Point(this.aimIconDict[_arg1].x, this.aimIconDict[_arg1].y));
            };
            return (null);
        }

        override public function dispose():void
        {
            var _local1:*;
            var _local2:Image;
            var _local3:TextSprite;
            super.dispose();
            MsgDispatcher.remove(GameEvents.AIMS_CHANGE, this.onAimChange);
            MsgDispatcher.remove(GameEvents.SCORE_CHANGE, this.onScoreChange);
            MsgDispatcher.remove(GameEvents.STEP_CHANGE, this.onStepChange);
            MsgDispatcher.remove(GameEvents.TIME_CHANGE, this.onTimeChange);
            for (_local1 in this.aimIconDict)
            {
                _local2 = this.aimIconDict[_local1];
                _local2.removeFromParent(true);
                _local2 = null;
                delete this.aimIconDict[_local1];
            };
            for (_local1 in this.aimLabelDict)
            {
                _local3 = this.aimLabelDict[_local1];
                _local3.removeFromParent(true);
                _local3 = null;
                delete this.aimLabelDict[_local1];
            };
        }


    }
}//package com.popchan.sugar.modules.game.view
