
package com.popchan.sugar.modules.menu.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.cfg.WindowInfo;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    
    import flash.display.BitmapData;
    
    import caurina.transitions.Tweener;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class SettingPanel extends Sprite 
    {

        private var setting_btn:Button;
        private var musicoff_btn:Button;
        private var musicon_btn:Button;
        private var soundoff_btn:Button;
        private var soundon_btn:Button;
        private var back_btn:Button;
        private var help_btn:Button;
        private var node:Sprite;
        private var isShow:Boolean;
        private var maskShape:Image;
        private var more_btn:Button;

        public function SettingPanel()
        {
            var _local1:BitmapData = new BitmapData(Core.stage3DManager.canvasWidth, Core.stage3DManager.canvasHeight, true, 0xAA000000);
            this.maskShape = new Image(Texture.fromBitmapData(_local1, false));
            addChild(this.maskShape);
            this.maskShape.visible = false;
            this.maskShape.addEventListener(TouchEvent.TOUCH, this.onBackTouch);
            this.node = new Sprite();
            this.addChild(this.node);
            var _local2:Image = ToolKit.createImage(this.node, Core.texturesManager.getTexture("circle"));
            this.node.addChild(_local2);
            _local2.touchable = false;
            this.musicoff_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("musicoff_btn"), 133, 58, this.onBtnTouch);
            this.musicon_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("musicon_btn"), 133, 58, this.onBtnTouch);
            this.soundoff_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("soundoff_btn"), 188, 175, this.onBtnTouch);
            this.soundon_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("soundon_btn"), 188, 175, this.onBtnTouch);
            this.back_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("back_btn"), 10, 0, this.onBtnTouch);
            this.more_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("more_btn"), 10, 0, this.onBtnTouch);
            this.more_btn.visible = false;
            this.more_btn.scaleX = (this.more_btn.scaleY = 0.5);
            this.musicoff_btn.scaleX = (this.musicoff_btn.scaleY = 0.75);
            this.musicon_btn.scaleX = (this.musicon_btn.scaleY = 0.75);
            this.soundoff_btn.scaleX = (this.soundoff_btn.scaleY = 0.75);
            this.soundon_btn.scaleX = (this.soundon_btn.scaleY = 0.75);
            this.back_btn.scaleX = (this.back_btn.scaleY = 0.75);
            this.setting_btn = new Button(Core.texturesManager.getTexture("setting_btn"), "", Core.texturesManager.getTexture("setting_btn2"));
            this.setting_btn.x = 0;
            this.setting_btn.y = 624;
            this.setting_btn.addEventListener(Event.TRIGGERED, this.onBtnTouch);
            this.addChild(this.setting_btn);
            this.node.scaleX = 0;
            this.node.scaleY = 0;
            this.node.visible = false;
            this.node.pivotX = 0;
            this.node.pivotY = 267;
            this.node.y = 700;
            this.isShow = false;
            this.setSound(Model.settingModel.sound);
            this.setMusic(Model.settingModel.music);
        }

        private function onBackTouch(_arg1:TouchEvent):void
        {
            var _local2:Touch = _arg1.getTouch(stage, TouchPhase.ENDED);
            if (_local2)
            {
                this.hide();
            }
        }

        private function hideQuit():void
        {
            this.back_btn.visible = false;
            this.more_btn.visible = true;
        }

        private function onBtnTouch(_arg1:Event):void
        {
            var _local2:Button = (_arg1.target as Button);
            SoundManager.instance.playSound("button_down", false);
            if (_local2 == this.setting_btn)
            {
                if (!this.isShow)
                {
                    this.show();
                }
                else
                {
                    this.hide();
                }
            }
            else
            {
                if (_local2 == this.back_btn)
                {
                    this.hide();
                    WindowManager3D.getInstance().removeWindow(WindowInfo.mapPanelInfo[0]);
                    MsgDispatcher.execute(GameEvents.OPEN_MENU_UI);
                }
                else
                {
                    if (_local2 == this.soundon_btn)
                    {
                        this.setSound(false);
                    }
                    else
                    {
                        if (_local2 == this.soundoff_btn)
                        {
                            this.setSound(true);
                        }
                        else
                        {
                            if (_local2 == this.musicon_btn)
                            {
                                this.setMusic(false);
                            }
                            else
                            {
                                if (_local2 == this.musicoff_btn)
                                {
                                    this.setMusic(true);
                                }
                                else
                                {
                                    if (_local2 == this.more_btn)
                                    {
//                                        if (SugarCrush.serviceHold)
//                                        {
//                                            SugarCrush.serviceHold.showGameList();
//                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        public function show():void
        {
            this.node.visible = true;
            this.node.scaleX = 0;
            this.node.scaleY = 0;
            Tweener.addTween(this.node, {
                "scaleX":1,
                "scaleY":1,
                "time":0.8,
                "transition":"easeOutElastic"
            });
            this.isShow = true;
            this.maskShape.visible = true;
        }

        private function hide():void
        {
            this.node.visible = false;
            Tweener.removeTweens(this.node);
            this.node.scaleX = 0;
            this.node.scaleY = 0;
            this.isShow = false;
            this.maskShape.visible = false;
            Model.settingModel.saveData();
        }

        public function set data(_arg1:Object):void
        {
            if (_arg1 == 1)
            {
                this.hideQuit();
            }
        }

        public function setSound(_arg1:Boolean):void
        {
            Model.settingModel.sound = _arg1;
            SoundManager.instance.muteSoundEffect(!(_arg1));
            this.soundoff_btn.visible = !(Model.settingModel.sound);
            this.soundon_btn.visible = Model.settingModel.sound;
        }

        public function setMusic(_arg1:Boolean):void
        {
            Model.settingModel.music = _arg1;
            SoundManager.instance.muteMusic(!(_arg1));
            this.musicoff_btn.visible = !(Model.settingModel.music);
            this.musicon_btn.visible = Model.settingModel.music;
        }


    }
}//package com.popchan.sugar.modules.menu.view
