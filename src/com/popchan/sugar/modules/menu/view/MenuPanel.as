
package com.popchan.sugar.modules.menu.view
{
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.Button;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.display.Image;
    import caurina.transitions.Tweener;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.sugar.core.events.GameEvents;
    import starling.events.Event;

    public class MenuPanel extends BasePanel3D 
    {

        private var playBtn:Button;

        public function MenuPanel()
        {
            ToolKit.createImage(this, Core.texturesManager.getTexture("title_bg"), 0, 0);
            ToolKit.createImage(this, Core.texturesManager.getTexture("zwsf"), 430, 640);
            var _local1:Image = ToolKit.createImage(this, Core.texturesManager.getTexture("title"));
            _local1.pivotX = (_local1.width >> 1);
            _local1.y = -200;
            _local1.x = (Core.stage3DManager.canvasWidth >> 1);
            Tweener.addTween(_local1, {
                "time":1.4,
                "y":0,
                "transition":"easeoutElastic"
            });
            this.playBtn = ToolKit.createButton(this, Core.texturesManager.getTexture("play_btn"), 0, 0, this.onBtnTouch);
            this.playBtn.pivotX = (this.playBtn.width >> 1);
            this.playBtn.pivotY = (this.playBtn.height >> 1);
            this.playBtn.x = (Core.stage3DManager.canvasWidth >> 1);
            this.playBtn.y = 400;
            this.playBtn.scaleX = 0;
            this.playBtn.scaleY = 0;
            Tweener.addTween(this.playBtn, {
                "delay":0.6,
                "scaleX":1,
                "scaleY":1,
                "time":0.5,
                "transition":"easeOutBounce",
                "onComplete":this.onActionEnd
            });
            var _local2:SettingPanel = new SettingPanel();
            _local2.data = 1;
            addChild(_local2);
            SoundManager.instance.playSound("bg", true, 0, 10000);
        }

        private function onActionEnd():void
        {
            this.doPlayAnimation();
        }

        private function onScaleEnd1():void
        {
            Tweener.addTween(this.playBtn, {
                "time":1,
                "scaleX":1,
                "scaleY":1,
                "onComplete":this.onScaleEnd2,
                "transition":"easeOutElastic"
            });
        }

        override public function show(_arg1:*):void
        {
            super.show(_arg1);
        }

        private function onScaleEnd2():void
        {
            this.doPlayAnimation();
        }

        private function doPlayAnimation():void
        {
            var _local1:Number = ((Math.random() * 3) + 1);
            Tweener.addTween(this.playBtn, {
                "time":0.2,
                "delay":_local1,
                "scaleX":1.2,
                "scaleY":0.8,
                "onComplete":this.onScaleEnd1
            });
        }

        private function onBtnTouch(_arg1:Event):void
        {
            if (_arg1.currentTarget == this.playBtn)
            {
                SoundManager.instance.playSound("button_down", false);
                close();
                MsgDispatcher.execute(GameEvents.OPEN_MAP_UI);
            }
        }


    }
}