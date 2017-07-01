
package com.popchan.sugar.modules.end.view
{
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.Sprite;
    import starling.display.Button;
    import starling.display.Image;
    import starling.text.TextField;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.sugar.modules.map.vo.LevelVO;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import caurina.transitions.Tweener;
    import starling.utils.HAlign;
    import com.popchan.sugar.core.Model;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.sugar.core.cfg.Config;
    import flash.utils.setTimeout;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.cfg.LevelConfig;
    import starling.events.Event;
    import flash.utils.setInterval;
    import flash.utils.clearInterval;
    import com.popchan.sugar.modules.game.ParticlePool;
    import starling.extensions.PDParticleSystem;
    import starling.core.Starling;

    public class GameEndPanel extends BasePanel3D 
    {

        public static const exp_res:Class = GameEndPanel_exp_res;

        private var node:Sprite;
        private var close_btn:Button;
        private var next_btn:Button;
        private var replay2_btn:Button;
        private var success:Image;
        private var failed:Image;
        private var scrollDelta:int;
        private var score:int;
        private var goldDelta:int;
        private var gold:int;
        private var getGold:int;
        private var starSoundIndex:int;
        private var scoreIntervalID:int;
        private var goldIntervalID:int;
        private var scoreLabel:TextField;
        private var highscoreLabel:TextField;
        private var goldLabel:TextField;

        public function GameEndPanel()
        {
            var getStar:int;
            var cfg:LevelCO;
            var i:int;
            var levelVO:LevelVO;
            var bigstar:Image;
            super();
            node = new Sprite();
            addChild(node);
            ToolKit.createImage(node, Core.texturesManager.getTexture("endPanel"), 0, 0);
            ToolKit.createImage(node, Core.texturesManager.getTexture("endscoreinfo"), 86, 216);
            success = ToolKit.createImage(node, Core.texturesManager.getTexture("success"), 165, 5);
            failed = ToolKit.createImage(node, Core.texturesManager.getTexture("failed"), 165, 5);
            next_btn = ToolKit.createButton(node, Core.texturesManager.getTexture("next_btn"), 177, 436, onBtnTouch);
            close_btn = ToolKit.createButton(node, Core.texturesManager.getTexture("close_btn"), 452, 24, onBtnTouch);
            replay2_btn = ToolKit.createButton(node, Core.texturesManager.getTexture("replay2_btn"), 177, 436, onBtnTouch);
            node.pivotX = 267;
            node.pivotY = 564;
            node.x = (Core.stage3DManager.canvasWidth >> 1);
            Tweener.addTween(node, {
                "time":0.3,
                "y":680,
                "transition":"easeOutBack"
            });
            Tweener.addTween(node, {
                "time":0.2,
                "delay":0.25,
                "scaleX":1.1,
                "scaleY":0.9,
                "onComplete":doUiAnimationEnd1,
                "transition":"linear"
            });
            scoreLabel = new TextField(200, 50, "", "endScoreFont", 30);
            scoreLabel.hAlign = HAlign.LEFT;
            scoreLabel.color = 0xFFFFFF;
            scoreLabel.x = 240;
            scoreLabel.y = 230;
            node.addChild(scoreLabel);
            goldLabel = new TextField(200, 50, "", "endScoreFont", 30);
            goldLabel.hAlign = HAlign.LEFT;
            goldLabel.color = 0xFFFFFF;
            goldLabel.x = 250;
            goldLabel.y = 313;
            node.addChild(goldLabel);
            highscoreLabel = new TextField(200, 50, "", "endHighScore", 30);
            highscoreLabel.hAlign = HAlign.LEFT;
            highscoreLabel.color = 0xFFFFFF;
            highscoreLabel.x = 240;
            highscoreLabel.y = 314;
            node.addChild(highscoreLabel);
            if (Model.gameModel.score > Model.gameModel.highScore)
            {
                Model.gameModel.highScore = Model.gameModel.score;
            }
            highscoreLabel.text = (Model.gameModel.highScore + "");
            SoundManager.instance.stopAllSound();
            if (Model.gameModel.isSuccess)
            {
                SoundManager.instance.playSound("game_win");
                getStar = 3;
                cfg = Config.levelConfig.getLevel(Model.levelModel.selectedLevel);
                if (Model.gameModel.score >= (cfg.needScore * 6))
                {
                    getStar = 3;
                }
                else if (Model.gameModel.score >= (cfg.needScore * 3))
                {
                    getStar = 2;
                } 
				else if (Model.gameModel.score >= cfg.needScore)
				{
					getStar = 1;
				}
                i = 0;
                while (i < getStar)
                {
                    bigstar = ToolKit.createImage(node, Core.texturesManager.getTexture("bigstar"), 91, -65);
                    bigstar.x = (167 + (i * 97));
                    bigstar.y = 131;
                    bigstar.scaleX = (bigstar.scaleY = 4);
                    bigstar.alpha = 0;
                    bigstar.pivotX = (78 >> 1);
                    bigstar.pivotY = (76 >> 1);
                    Tweener.addTween(bigstar, {
                        "delay":((i * 0.3) + 0.8),
                        "time":0.5,
                        "scaleX":1,
                        "scaleY":1,
                        "transition":"easeOutBack"
                    });
                    Tweener.addTween(bigstar, {
                        "delay":((i * 0.3) + 0.8),
                        "time":0.3,
                        "alpha":1,
                        "onCompleteParams":[bigstar],
                        "onComplete":function (_arg1:Image):void
                        {
                            creatExpEffect(_arg1.x, _arg1.y);
                        }
                    });
                    i = (i + 1);
                }
                success.visible = true;
                failed.visible = false;
                replay2_btn.visible = false;
                if (Model.levelModel.currentLevel == Model.levelModel.selectedLevel)
                {
                    Model.levelModel.currentLevel++;
                    if (Model.levelModel.currentLevel > Model.levelModel.totalLevel)
                    {
                        Model.levelModel.currentLevel = Model.levelModel.totalLevel;
                    }
                }
                levelVO = Model.levelModel.getLevelVO(Model.levelModel.selectedLevel);
                levelVO.star = getStar;
                levelVO.highscore = Model.gameModel.highScore;
            }
            else
            {
                success.visible = false;
                failed.visible = true;
                next_btn.visible = false;
                getGold = 0;
                SoundManager.instance.playSound("fail1");
            }
            setTimeout(delayToScroll, 400);
            starSoundIndex = 0;
            Model.levelModel.saveData();
        }

        override public function show(_arg1:*):void
        {
            super.show(_arg1);
        }

        private function onBtnTouch(_arg1:Event):void
        {
            var currentLevel:int;
            var selectedLevel:int;
            var targetBtn:Button = (_arg1.currentTarget as Button);
            SoundManager.instance.playSound("button_down", false);
            if (targetBtn == close_btn)
            {
                WindowManager3D.getInstance().removeAll();
                MsgDispatcher.execute(GameEvents.OPEN_MAP_UI);
            }
            else
            {
                if (targetBtn == replay2_btn)
                {
                    WindowManager3D.getInstance().removeAll();
                    MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
                }
                else
                {
                    if (targetBtn == next_btn)
                    {
                        currentLevel = Model.levelModel.currentLevel;
                        selectedLevel = Model.levelModel.selectedLevel;
                        WindowManager3D.getInstance().removeAll();
                        Model.levelModel.selectedLevel = Math.min((Model.levelModel.selectedLevel + 1), LevelConfig.TOTAL_LEVEL);
                        MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
                    }
                }
            }
        }

        private function delayToScroll():void
        {
            scrollDelta = (Model.gameModel.score / 60);
            if (scrollDelta == 0)
            {
                scrollDelta = 1;
            }
            scoreIntervalID = setInterval(scoreScroll, 16);
            score = 0;
            if (getGold > 0)
            {
                goldDelta = (getGold / 60);
                if (goldDelta == 0)
                {
                    goldDelta = 1;
                }
                goldIntervalID = setInterval(goldScroll, 16);
                gold = 0;
            }
        }

        private function scoreScroll():void
        {
            score = (score + scrollDelta);
            if (score >= Model.gameModel.score)
            {
                score = Model.gameModel.score;
                clearInterval(scoreIntervalID);
            }
            scoreLabel.text = (score + "");
        }

        private function goldScroll():void
        {
            gold = (gold + goldDelta);
            if (gold >= getGold)
            {
                gold = getGold;
                clearInterval(goldIntervalID);
            }
            goldLabel.text = (gold + "");
        }

        private function restartGame():void
        {
        }

        private function back():void
        {
        }

        private function creatExpEffect(posX:Number, posY:Number):void
        {
            var pdParticleSystem:PDParticleSystem = ParticlePool.instance.getParticleByType(5);
            Starling.juggler.add(pdParticleSystem);
            pdParticleSystem.x = posX;
            pdParticleSystem.y = posY;
            pdParticleSystem.start(0.05);
            pdParticleSystem.addEventListener(Event.COMPLETE, onParticleCom);
            node.addChild(pdParticleSystem);
            starSoundIndex++;
            SoundManager.instance.playSound(("completeStar" + starSoundIndex), false);
        }

        private function onParticleCom(event:Event):void
        {
            var pdParticleSystem:PDParticleSystem = (event.currentTarget as PDParticleSystem);
            pdParticleSystem.removeEventListener(Event.COMPLETE, onParticleCom);
            ParticlePool.instance.returnParticle(pdParticleSystem.tag, pdParticleSystem);
            node.removeChild(pdParticleSystem);
        }

        private function doUiAnimationEnd1():void
        {
            Tweener.addTween(node, {
                "time":1,
                "scaleX":1,
                "scaleY":1,
                "transition":"easeOutElastic"
            });
        }


    }
} 