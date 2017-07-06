
package com.popchan.sugar.modules.game.view.panel
{
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.Button;
    import starling.display.Sprite;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import flash.geom.Point;
    import caurina.transitions.Tweener;
    import com.popchan.sugar.core.Model;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import starling.events.Event;

    public class PausePanel extends BasePanel3D 
    {

        private var soundoff_btn:Button;
        private var soundon_btn:Button;
        private var back_btn:Button;
        private var continue_btn:Button;
        private var retry_btn:Button;
        private var musicoff_btn:Button;
        private var musicon_btn:Button;
        private var btns:Array;
        private var points:Array;

        public function PausePanel()
        {
            var _local1:Sprite = new Sprite();
            this.addChild(_local1);
            this.back_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("back_btn"), 320, 400, this.onBtnTouch);
            this.musicoff_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("musicoff_btn"), 147, 406, this.onBtnTouch);
            this.musicon_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("musicon_btn"), 147, 406, this.onBtnTouch);
            this.soundon_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("soundon_btn"), 147, 406, this.onBtnTouch);
            this.soundoff_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("soundoff_btn"), 147, 406, this.onBtnTouch);
            this.continue_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("continue_btn"), 147, 406, this.onBtnTouch);
            this.retry_btn = ToolKit.createButton(_local1, Core.texturesManager.getTexture("retry_btn"), 147, 406, this.onBtnTouch);
            this.back_btn.scaleX = (this.back_btn.scaleY = 0.8);
            this.back_btn.pivotX = (this.back_btn.width >> 1);
            this.back_btn.pivotY = (this.back_btn.height >> 1);
            this.btns = [];
            this.btns.push(this.musicoff_btn);
            this.btns.push(this.musicon_btn);
            this.btns.push(this.soundon_btn);
            this.btns.push(this.soundoff_btn);
            this.btns.push(this.continue_btn);
            this.btns.push(this.retry_btn);
            this.points = [];
            this.points.push(new Point(140, 400));
            this.points.push(new Point(140, 400));
            this.points.push(new Point(500, 400));
            this.points.push(new Point(500, 400));
            this.points.push(new Point(320, 220));
            this.points.push(new Point(320, 580));
            this.setSound();
            this.setMusic();
        }

        override public function show(_arg1:*):void
        {
            var button:Button;
            super.show(_arg1);
            this.back_btn.scaleX = (this.back_btn.scaleY = 0);
            Tweener.addTween(this.back_btn, {
                "time":0.6,
                "scaleX":0.8,
                "scaleY":0.8,
                "transition":"easeOutBack"
            });
            var _local2:int;
            while (_local2 < this.btns.length)
            {
                button = this.btns[_local2];
                button.scaleX = (button.scaleY = 0.8);
                button.pivotX = (button.width >> 1);
                button.pivotY = (button.height >> 1);
                button.x = 320;
                button.y = 400;
                Tweener.addTween(button, {
                    "time":0.5,
                    "x":this.points[_local2].x,
                    "y":this.points[_local2].y,
                    "transition":"easeOutBack"
                });
                _local2++;
            }
        }

        override public function close():void
        {
            super.close();
            Model.settingModel.saveData();
        }

        private function onBtnTouch(_arg1:Event):void
        {
            SoundManager.instance.playSound("button_down", false);
            var _local2:Button = (_arg1.currentTarget as Button);
            if (_local2 == this.continue_btn)
            {
                this.close();
            }
            else
            {
                if (_local2 == this.back_btn)
                {
                    WindowManager3D.getInstance().removeAll();
                    MsgDispatcher.execute(GameEvents.OPEN_MAP_UI);
                }
                else
                {
                    if (_local2 == this.retry_btn)
                    {
                        WindowManager3D.getInstance().removeAll();
                        MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
                    }
                    else
                    {
                        if (_local2 == this.soundon_btn)
                        {
                            Model.settingModel.sound = false;
                            SoundManager.instance.muteSoundEffect(true);
                            this.setSound();
                        }
                        else
                        {
                            if (_local2 == this.soundoff_btn)
                            {
                                Model.settingModel.sound = true;
                                SoundManager.instance.muteSoundEffect(false);
                                this.setSound();
                            }
                            else
                            {
                                if (_local2 == this.musicon_btn)
                                {
                                    Model.settingModel.music = false;
                                    SoundManager.instance.muteMusic(true);
                                    this.setMusic();
                                }
                                else
                                {
                                    if (_local2 == this.musicoff_btn)
                                    {
                                        Model.settingModel.music = true;
                                        SoundManager.instance.muteMusic(false);
                                        this.setMusic();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public function setSound():void
        {
            this.soundoff_btn.visible = !(Model.settingModel.sound);
            this.soundon_btn.visible = Model.settingModel.sound;
        }

        public function setMusic():void
        {
            this.musicoff_btn.visible = !(Model.settingModel.music);
            this.musicon_btn.visible = Model.settingModel.music;
        }


    }
}//package com.popchan.sugar.modules.game.view
